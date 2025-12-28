#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

FREED_SPACE=0
SCRIPT_VERSION="2.0.0"

print_header() {
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
}

print_step() {
    echo -e "${GREEN}▶ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_danger() {
    echo -e "${RED}☢ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ ERROR: $1${NC}" >&2
}

get_size() {
    local path="$1"
    if [[ -d "$path" ]]; then
        du -sb "$path" 2>/dev/null | cut -f1 || echo 0
    elif [[ -f "$path" ]]; then
        stat -c%s "$path" 2>/dev/null || echo 0
    else
        echo 0
    fi
}

human_readable() {
    numfmt --to=iec-i --suffix=B "$1" 2>/dev/null || echo "$1 B"
}

add_freed() {
    local amount=$1
    if (( amount > 0 )); then
        FREED_SPACE=$((FREED_SPACE + amount))
        echo -e "   ${GREEN}+$(human_readable $amount)${NC}"
    fi
}

safe_rm() {
    local path="$1"
    if [[ -e "$path" ]]; then
        rm -rf "$path" 2>/dev/null || {
            print_warning "Failed to remove: $path"
            return 1
        }
    fi
    return 0
}

cleanup_pacman() {
    print_header "PACMAN / PARU [AGGRESSIVE]"
    
    print_step "Удаление осиротевших пакетов..."
    local orphans
    orphans=$(pacman -Qtdq 2>/dev/null || true)
    if [[ -n "$orphans" ]]; then
        echo "$orphans"
        sudo pacman -Rns $orphans --noconfirm 2>/dev/null || true
        echo -e "   ${GREEN}Удалено!${NC}"
    else
        echo "   Нет сирот"
    fi
    
    print_step "Поиск ненужных опциональных зависимостей..."
    local optional
    optional=$(pacman -Qdtq 2>/dev/null || true)
    if [[ -n "$optional" ]]; then
        echo "$optional"
        read -p "Удалить? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo pacman -Rns $optional --noconfirm 2>/dev/null || true
        fi
    fi
    
    print_step "Агрессивная очистка кэша pacman (оставляем только 1 версию)..."
    local cache_before
    cache_before=$(get_size /var/cache/pacman/pkg)
    
    if command -v paccache &> /dev/null; then
        sudo paccache -rk1 -q
        sudo paccache -ruk0 -q
    else
        sudo pacman -Scc --noconfirm
    fi
    
    local cache_after
    cache_after=$(get_size /var/cache/pacman/pkg)
    add_freed $((cache_before - cache_after))
    
    print_step "Полная очистка кэша paru..."
    if [[ -d "$HOME/.cache/paru" ]]; then
        local paru_size
        paru_size=$(get_size "$HOME/.cache/paru")
        safe_rm "$HOME/.cache/paru"/*
        add_freed $paru_size
    fi
    
    print_step "Поиск .pacsave и .pacnew файлов..."
    local pacfiles
    pacfiles=$(sudo find /etc -name "*.pacsave" -o -name "*.pacnew" 2>/dev/null || true)
    if [[ -n "$pacfiles" ]]; then
        echo "$pacfiles"
        read -p "Удалить эти файлы? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "$pacfiles" | xargs -r sudo rm -f
        fi
    fi
}

cleanup_rust() {
    print_header "RUST / CARGO [AGGRESSIVE]"
    
    if ! command -v cargo &> /dev/null; then
        print_warning "Cargo не найден, пропуск..."
        return
    fi
    
    print_step "Полная очистка ~/.cargo (registry, git, cache)..."
    
    local dirs_to_clean=(
        "$HOME/.cargo/registry/cache"
        "$HOME/.cargo/registry/src"
        "$HOME/.cargo/registry/index"
        "$HOME/.cargo/git/checkouts"
        "$HOME/.cargo/git/db"
    )
    
    for dir in "${dirs_to_clean[@]}"; do
        if [[ -d "$dir" ]]; then
            local size
            size=$(get_size "$dir")
            safe_rm "$dir"/*
            echo "   $dir"
            add_freed $size
        fi
    done
    
    print_step "Удаление ВСЕХ target директорий..."
    
    local total=0
    while IFS= read -r -d '' dir; do
        if [[ -n "$dir" ]]; then
            local size
            size=$(get_size "$dir")
            total=$((total + size))
            safe_rm "$dir"
            echo "   Удалено: $dir ($(human_readable $size))"
        fi
    done < <(find "$HOME" -maxdepth 6 -type d -name "target" -exec test -f "{}/../Cargo.toml" \; -print0 2>/dev/null)
    
    add_freed $total
    
    print_step "Очистка старых Rust toolchains..."
    if command -v rustup &> /dev/null; then
        rustup toolchain list
        
        local default_tc
        default_tc=$(rustup default | cut -d' ' -f1)
        while IFS= read -r tc; do
            tc=$(echo "$tc" | cut -d' ' -f1)
            if [[ "$tc" != "$default_tc" && -n "$tc" ]]; then
                echo "   Удаляю toolchain: $tc"
                rustup toolchain uninstall "$tc" 2>/dev/null || true
            fi
        done < <(rustup toolchain list | grep -v "^$default_tc")
        
        if [[ -d "$HOME/.rustup/downloads" ]]; then
            local rustup_size
            rustup_size=$(get_size "$HOME/.rustup/downloads")
            safe_rm "$HOME/.rustup/downloads"/*
            add_freed $rustup_size
        fi
        
        [[ -d "$HOME/.rustup/tmp" ]] && safe_rm "$HOME/.rustup/tmp"/*
    fi
}

cleanup_java() {
    print_header "JAVA (Maven + Gradle) [AGGRESSIVE]"
    
    if [[ -d "$HOME/.m2" ]]; then
        print_step "Полная очистка Maven..."
        local m2_size
        m2_size=$(get_size "$HOME/.m2/repository")
        safe_rm "$HOME/.m2/repository"
        echo "   ~/.m2/repository удалён"
        add_freed $m2_size
        
        if [[ -d "$HOME/.m2/wrapper" ]]; then
            local wrapper_size
            wrapper_size=$(get_size "$HOME/.m2/wrapper")
            safe_rm "$HOME/.m2/wrapper"
            add_freed $wrapper_size
        fi
    fi
    
    if [[ -d "$HOME/.gradle" ]]; then
        print_step "Полная очистка Gradle..."
        
        local gradle_dirs=(
            "$HOME/.gradle/caches"
            "$HOME/.gradle/daemon"
            "$HOME/.gradle/wrapper"
            "$HOME/.gradle/native"
            "$HOME/.gradle/jdks"
            "$HOME/.gradle/build-scan-data"
        )
        
        for dir in "${gradle_dirs[@]}"; do
            if [[ -d "$dir" ]]; then
                local size
                size=$(get_size "$dir")
                safe_rm "$dir"
                echo "   Удалено: $dir"
                add_freed $size
            fi
        done
    fi
    
    print_step "Удаление всех build директорий..."
    local total=0
    
    while IFS= read -r -d '' dir; do
        if [[ -n "$dir" ]]; then
            local size
            size=$(get_size "$dir")
            total=$((total + size))
            safe_rm "$dir"
        fi
    done < <(find "$HOME" -maxdepth 6 -type d -name "build" \
        \( -exec test -f "{}/../build.gradle" \; -o -exec test -f "{}/../build.gradle.kts" \; \) \
        -print0 2>/dev/null)
    
    while IFS= read -r -d '' dir; do
        if [[ -n "$dir" ]]; then
            local size
            size=$(get_size "$dir")
            total=$((total + size))
            safe_rm "$dir"
        fi
    done < <(find "$HOME" -maxdepth 6 -type d -name "target" \
        -exec test -f "{}/../pom.xml" \; -print0 2>/dev/null)
    
    add_freed $total
    
    print_step "Очистка Java кэшей..."
    local java_caches=(
        "$HOME/.java"
        "$HOME/.oracle_jre_usage"
        "$HOME/.jmc"
        "$HOME/.visualvm"
    )
    
    for cache in "${java_caches[@]}"; do
        if [[ -d "$cache" ]]; then
            local size
            size=$(get_size "$cache")
            safe_rm "$cache"
            add_freed $size
        fi
    done
}

cleanup_intellij() {
    print_header "INTELLIJ IDEA [AGGRESSIVE]"
    
    local idea_dirs=(
        "$HOME/.config/JetBrains"
        "$HOME/.local/share/JetBrains"
        "$HOME/.cache/JetBrains"
    )
    
    local found=false
    for dir in "${idea_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            found=true
            break
        fi
    done
    
    if [[ "$found" == false ]]; then
        print_warning "IntelliJ IDEA не найден, пропуск..."
        return
    fi
    
    print_step "Размеры директорий IntelliJ IDEA:"
    for dir in "${idea_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            echo "   $dir: $(human_readable $(get_size "$dir"))"
        fi
    done
    
    print_step "Очистка кэша IntelliJ IDEA..."
    if [[ -d "$HOME/.cache/JetBrains" ]]; then
        local cache_size
        cache_size=$(get_size "$HOME/.cache/JetBrains")
        safe_rm "$HOME/.cache/JetBrains"/*
        echo "   Очищено: $HOME/.cache/JetBrains"
        add_freed $cache_size
    fi
    
    print_step "Очистка системного кэша..."
    local system_cache="$HOME/.local/share/JetBrains"
    if [[ -d "$system_cache" ]]; then
        find "$system_cache" -type d -name "log" -exec rm -rf {} + 2>/dev/null || true
        find "$system_cache" -type d -name "tmp" -exec rm -rf {} + 2>/dev/null || true
        find "$system_cache" -name "*.log" -delete 2>/dev/null || true
    fi
    
    print_step "Очистка кэшей конфигураций..."
    local config_base="$HOME/.config/JetBrains"
    if [[ -d "$config_base" ]]; then
        local internal_caches=(
            "system/caches"
            "system/compile-server"
            "system/compiler"
            "system/tmp"
            "system/index"
            "log"
        )
        
        for idea_version in "$config_base"/*; do
            if [[ -d "$idea_version" ]]; then
                for cache in "${internal_caches[@]}"; do
                    if [[ -d "$idea_version/$cache" ]]; then
                        local size
                        size=$(get_size "$idea_version/$cache")
                        safe_rm "$idea_version/$cache"
                        add_freed $size
                    fi
                done
            fi
        done
    fi
    
    print_step "Удаление старых версий IntelliJ IDEA..."
    if [[ -d "$config_base" ]]; then
        local versions
        versions=$(find "$config_base" -maxdepth 1 -type d -name "IntelliJIdea*" -o -name "IdeaIC*" | sort -V)
        local version_count
        version_count=$(echo "$versions" | grep -c "^" || echo 0)
        
        if [[ $version_count -gt 2 ]]; then
            echo "   Найдено версий: $version_count"
            echo "$versions" | head -n -2 | while IFS= read -r old_version; do
                if [[ -n "$old_version" ]]; then
                    echo "   Удаляю старую версию: $(basename "$old_version")"
                    read -p "   Подтвердить? [y/N] " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        local size
                        size=$(get_size "$old_version")
                        safe_rm "$old_version"
                        add_freed $size
                    fi
                fi
            done
        fi
    fi
    
    print_step "Очистка Maven репозитория IntelliJ..."
    if [[ -d "$HOME/.m2/repository" ]]; then
        local m2_cache="$HOME/.m2/repository/.cache"
        if [[ -d "$m2_cache" ]]; then
            local cache_size
            cache_size=$(get_size "$m2_cache")
            safe_rm "$m2_cache"
            add_freed $cache_size
        fi
    fi
}

cleanup_bun() {
    print_header "BUN / NPM / NODE [AGGRESSIVE]"
    
    if [[ -d "$HOME/.bun" ]]; then
        print_step "Полная очистка Bun cache..."
        local bun_cache
        bun_cache=$(get_size "$HOME/.bun/install/cache")
        safe_rm "$HOME/.bun/install/cache"/*
        add_freed $bun_cache
    fi
    
    if [[ -d "$HOME/.npm" ]]; then
        print_step "Полная очистка NPM..."
        local npm_size
        npm_size=$(get_size "$HOME/.npm")
        safe_rm "$HOME/.npm"/*
        add_freed $npm_size
    fi
    
    if [[ -d "$HOME/.yarn" ]]; then
        print_step "Очистка Yarn cache..."
        local yarn_size
        yarn_size=$(get_size "$HOME/.yarn/cache")
        safe_rm "$HOME/.yarn/cache"/* 2>/dev/null || true
        command -v yarn &> /dev/null && yarn cache clean 2>/dev/null || true
        add_freed $yarn_size
    fi
    
    if [[ -d "$HOME/.local/share/pnpm" ]]; then
        print_step "Очистка PNPM..."
        local pnpm_size
        pnpm_size=$(get_size "$HOME/.local/share/pnpm/store")
        safe_rm "$HOME/.local/share/pnpm/store"/* 2>/dev/null || true
        add_freed $pnpm_size
    fi
    
    print_step "Удаление ВСЕХ node_modules..."
    local total=0
    local count=0
    
    while IFS= read -r -d '' dir; do
        if [[ -n "$dir" ]]; then
            local size
            size=$(get_size "$dir")
            total=$((total + size))
            count=$((count + 1))
            safe_rm "$dir"
        fi
    done < <(find "$HOME" -maxdepth 6 -type d -name "node_modules" -prune -print0 2>/dev/null)
    
    echo "   Удалено $count директорий"
    add_freed $total
    
    print_step "Удаление build директорий (.next, .nuxt, dist, .output)..."
    local build_dirs=(".next" ".nuxt" ".output" "dist" ".cache" ".turbo" ".parcel-cache")
    
    for build_name in "${build_dirs[@]}"; do
        while IFS= read -r -d '' dir; do
            if [[ -n "$dir" ]]; then
                local size
                size=$(get_size "$dir")
                safe_rm "$dir"
                add_freed $size
            fi
        done < <(find "$HOME" -maxdepth 6 -type d -name "$build_name" \
            -not -path "*/\.*" -print0 2>/dev/null | head -z -50)
    done
}

cleanup_neovim() {
    print_header "NEOVIM [AGGRESSIVE]"
    
    print_step "Размеры директорий Neovim:"
    
    local nvim_dirs=(
        "$HOME/.config/nvim"
        "$HOME/.local/share/nvim"
        "$HOME/.local/state/nvim"
        "$HOME/.cache/nvim"
    )
    
    for dir in "${nvim_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            echo "   $dir: $(human_readable $(get_size "$dir"))"
        fi
    done
    
    print_step "Очистка кэша Neovim..."
    if [[ -d "$HOME/.cache/nvim" ]]; then
        local cache_size
        cache_size=$(get_size "$HOME/.cache/nvim")
        safe_rm "$HOME/.cache/nvim"/*
        add_freed $cache_size
    fi
    
    print_step "Очистка state (swap, undo, shada)..."
    local state_dirs=(
        "$HOME/.local/state/nvim/swap"
        "$HOME/.local/state/nvim/undo"
        "$HOME/.local/state/nvim/backup"
    )
    
    for dir in "${state_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            local size
            size=$(get_size "$dir")
            safe_rm "$dir"/*
            add_freed $size
        fi
    done
    
    if [[ -f "$HOME/.local/state/nvim/shada/main.shada" ]]; then
        local shada_size
        shada_size=$(get_size "$HOME/.local/state/nvim/shada/main.shada")
        if (( shada_size > 10485760 )); then
            print_warning "shada файл большой: $(human_readable $shada_size)"
            rm -f "$HOME/.local/state/nvim/shada/main.shada"
            add_freed $shada_size
        fi
    fi
    
    print_step "Очистка plugin manager кэшей..."
    
    if [[ -d "$HOME/.local/share/nvim/lazy" ]]; then
        local lazy_cache="$HOME/.local/share/nvim/lazy-lock.json.bak"
        [[ -f "$lazy_cache" ]] && rm -f "$lazy_cache"
    fi
    
    if [[ -d "$HOME/.local/share/nvim/site/pack/packer" ]]; then
        rm -f "$HOME/.local/share/nvim/plugin/packer_compiled.lua" 2>/dev/null || true
    fi
    
    if [[ -d "$HOME/.local/share/nvim/mason" ]]; then
        local mason_size
        mason_size=$(get_size "$HOME/.local/share/nvim/mason")
        echo ""
        print_danger "Mason (LSP серверы) занимает: $(human_readable $mason_size)"
        echo "   Это удалит ВСЕ LSP серверы (rust-analyzer, jdtls и т.д.)"
        echo "   Они скачаются заново при открытии nvim"
        read -p "   Удалить всё? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            safe_rm "$HOME/.local/share/nvim/mason"
            add_freed $mason_size
        fi
    fi
    
    if [[ -d "$HOME/.local/share/nvim/lazy/nvim-treesitter/parser" ]]; then
        local ts_size
        ts_size=$(get_size "$HOME/.local/share/nvim/lazy/nvim-treesitter/parser")
        if (( ts_size > 104857600 )); then
            print_warning "Treesitter parsers: $(human_readable $ts_size)"
            read -p "   Удалить? (пересоберутся при запуске) [y/N] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                safe_rm "$HOME/.local/share/nvim/lazy/nvim-treesitter/parser"/*
                add_freed $ts_size
            fi
        fi
    fi
}

cleanup_vscode() {
    print_header "VS CODE / CODE-OSS [AGGRESSIVE]"
    
    local config_dirs=(
        "$HOME/.config/Code - OSS"
        "$HOME/.config/Code"
        "$HOME/.config/VSCodium"
    )
    
    local cache_dirs=(
        "$HOME/.cache/Code - OSS"
        "$HOME/.cache/Code"
        "$HOME/.cache/VSCodium"
    )
    
    local data_dirs=(
        "$HOME/.vscode-oss"
        "$HOME/.vscode"
    )
    
    print_step "Размеры директорий VS Code:"
    
    for dir in "${config_dirs[@]}"; do
        [[ -d "$dir" ]] && echo "   $dir: $(human_readable $(get_size "$dir"))"
    done
    
    for dir in "${data_dirs[@]}"; do
        [[ -d "$dir" ]] && echo "   $dir: $(human_readable $(get_size "$dir"))"
    done
    
    print_step "Очистка кэша VS Code..."
    for dir in "${cache_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            local size
            size=$(get_size "$dir")
            safe_rm "$dir"/*
            echo "   Очищено: $dir"
            add_freed $size
        fi
    done
    
    print_step "Очистка внутренних кэшей..."
    for config_dir in "${config_dirs[@]}"; do
        if [[ -d "$config_dir" ]]; then
            local internal_caches=(
                "Cache"
                "CachedData"
                "CachedExtensions"
                "CachedExtensionVSIXs"
                "Code Cache"
                "GPUCache"
                "Service Worker/CacheStorage"
                "Service Worker/ScriptCache"
                "logs"
                "Crashpad"
            )
            
            for cache in "${internal_caches[@]}"; do
                if [[ -d "$config_dir/$cache" ]]; then
                    local size
                    size=$(get_size "$config_dir/$cache")
                    safe_rm "$config_dir/$cache"
                    add_freed $size
                fi
            done
            
            find "$config_dir" -name "*.backup" -delete 2>/dev/null || true
            find "$config_dir" -name "*.old" -delete 2>/dev/null || true
        fi
    done
    
    print_step "Очистка workspace storage..."
    for config_dir in "${config_dirs[@]}"; do
        local ws_storage="$config_dir/User/workspaceStorage"
        if [[ -d "$ws_storage" ]]; then
            local ws_size
            ws_size=$(get_size "$ws_storage")
            echo "   Workspace storage: $(human_readable $ws_size)"
            
            if (( ws_size > 104857600 )); then
                print_warning "Workspace storage большой!"
                read -p "   Удалить? (потеряется история workspace) [y/N] " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    safe_rm "$ws_storage"/*
                    add_freed $ws_size
                fi
            else
                safe_rm "$ws_storage"/*
                add_freed $ws_size
            fi
        fi
    done
    
    print_step "Очистка global storage кэшей..."
    for config_dir in "${config_dirs[@]}"; do
        local global_storage="$config_dir/User/globalStorage"
        if [[ -d "$global_storage" ]]; then
            find "$global_storage" -type d -name "cache" -exec rm -rf {} + 2>/dev/null || true
            find "$global_storage" -type d -name "Cache" -exec rm -rf {} + 2>/dev/null || true
            find "$global_storage" -name "*.log" -delete 2>/dev/null || true
        fi
    done
    
    print_step "Расширения VS Code..."
    for ext_dir in "${data_dirs[@]}/extensions"; do
        if [[ -d "$ext_dir" ]]; then
            local ext_size
            ext_size=$(get_size "$ext_dir")
            local ext_count
            ext_count=$(find "$ext_dir" -maxdepth 1 -type d | wc -l)
            echo "   $ext_dir: $(human_readable $ext_size) ($((ext_count - 1)) расширений)"
            
            if (( ext_size > 524288000 )); then
                echo ""
                print_danger "Расширения занимают много места!"
                echo "   Удаление приведёт к переустановке всех расширений"
                read -p "   Удалить все расширения? [y/N] " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    safe_rm "$ext_dir"/*
                    add_freed $ext_size
                fi
            fi
        fi
    done
    
    print_step "Очистка логов..."
    for config_dir in "${config_dirs[@]}"; do
        find "$config_dir" -name "*.log" -delete 2>/dev/null || true
        find "$config_dir" -type d -name "logs" -exec rm -rf {} + 2>/dev/null || true
    done
}

cleanup_zed() {
    print_header "ZED EDITOR [AGGRESSIVE]"
    
    print_step "Размеры директорий Zed:"
    
    if [[ -d "$HOME/.config/zed" ]]; then
        echo "   ~/.config/zed/: $(human_readable $(get_size "$HOME/.config/zed")) (конфиг)"
    fi
    
    if [[ -d "$HOME/.local/share/zed" ]]; then
        local share_size
        share_size=$(get_size "$HOME/.local/share/zed")
        echo "   ~/.local/share/zed/: $(human_readable $share_size)"
        
        for subdir in languages extensions node copilot; do
            if [[ -d "$HOME/.local/share/zed/$subdir" ]]; then
                echo "     └── $subdir/: $(human_readable $(get_size "$HOME/.local/share/zed/$subdir"))"
            fi
        done
    fi
    
    [[ -d "$HOME/.cache/zed" ]] && echo "   ~/.cache/zed/: $(human_readable $(get_size "$HOME/.cache/zed"))"
    
    print_step "Очистка кэша Zed..."
    if [[ -d "$HOME/.cache/zed" ]]; then
        local cache_size
        cache_size=$(get_size "$HOME/.cache/zed")
        safe_rm "$HOME/.cache/zed"/*
        add_freed $cache_size
    fi
    
    if [[ -d "$HOME/.local/share/zed/languages" ]]; then
        print_step "Удаление LSP серверов Zed..."
        local lsp_size
        lsp_size=$(get_size "$HOME/.local/share/zed/languages")
        safe_rm "$HOME/.local/share/zed/languages"/*
        add_freed $lsp_size
    fi
    
    if [[ -d "$HOME/.local/share/zed/node" ]]; then
        local node_size
        node_size=$(get_size "$HOME/.local/share/zed/node")
        safe_rm "$HOME/.local/share/zed/node"/*
        add_freed $node_size
    fi
    
    if [[ -d "$HOME/.local/share/zed/copilot" ]]; then
        local copilot_size
        copilot_size=$(get_size "$HOME/.local/share/zed/copilot")
        safe_rm "$HOME/.local/share/zed/copilot"/*
        add_freed $copilot_size
    fi
}

cleanup_docker() {
    print_header "DOCKER [NUCLEAR]"
    
    if ! command -v docker &> /dev/null; then
        print_warning "Docker не установлен"
        return
    fi
    
    if ! sudo docker info &> /dev/null 2>&1; then
        print_warning "Docker daemon не запущен"
        read -p "Запустить? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo systemctl start docker
            sleep 2
        else
            return
        fi
    fi
    
    print_step "Текущее использование:"
    sudo docker system df
    echo ""
    
    echo -e "${CYAN}Уровень очистки:${NC}"
    echo "  1) Мягкая - dangling images/containers"
    echo "  2) Средняя - все неиспользуемые ресурсы"
    echo "  3) ЯДЕРНАЯ - УДАЛИТЬ ВСЁ (образы, контейнеры, volumes, networks, build cache)"
    echo "  0) Пропустить"
    read -p "Выбор [3]: " docker_choice
    docker_choice=${docker_choice:-3}
    
    case $docker_choice in
        1)
            print_step "Мягкая очистка..."
            sudo docker container prune -f
            sudo docker image prune -f
            sudo docker network prune -f
            ;;
        2)
            print_step "Средняя очистка..."
            sudo docker system prune -af
            sudo docker volume prune -f
            ;;
        3)
            echo ""
            print_danger "ЯДЕРНАЯ ОЧИСТКА DOCKER"
            echo -e "${RED}"
            echo "   ╔═══════════════════════════════════════════════════╗"
            echo "   ║  ЭТО УДАЛИТ:                                      ║"
            echo "   ║  • Все контейнеры (включая запущенные)           ║"
            echo "   ║  • Все образы                                     ║"
            echo "   ║  • Все volumes (ДАННЫЕ ПОТЕРЯНЫ НАВСЕГДА!)       ║"
            echo "   ║  • Все networks                                   ║"
            echo "   ║  • Весь build cache                               ║"
            echo "   ╚═══════════════════════════════════════════════════╝"
            echo -e "${NC}"
            read -p "   Введите 'NUKE' для подтверждения: " confirm
            
            if [[ "$confirm" == "NUKE" ]]; then
                print_step "ЗАПУСК ЯДЕРНОЙ ОЧИСТКИ..."
                
                local running
                running=$(sudo docker ps -q)
                if [[ -n "$running" ]]; then
                    echo "   Останавливаем контейнеры..."
                    sudo docker stop $running 2>/dev/null || true
                fi
                
                local containers
                containers=$(sudo docker ps -aq)
                if [[ -n "$containers" ]]; then
                    echo "   Удаляем контейнеры..."
                    sudo docker rm -f $containers 2>/dev/null || true
                fi
                
                local images
                images=$(sudo docker images -q)
                if [[ -n "$images" ]]; then
                    echo "   Удаляем образы..."
                    sudo docker rmi -f $images 2>/dev/null || true
                fi
                
                local volumes
                volumes=$(sudo docker volume ls -q)
                if [[ -n "$volumes" ]]; then
                    echo "   Удаляем volumes..."
                    sudo docker volume rm -f $volumes 2>/dev/null || true
                fi
                
                sudo docker system prune -af --volumes 2>/dev/null || true
                sudo docker builder prune -af 2>/dev/null || true
                
                if [[ -d "/var/lib/docker" ]]; then
                    echo "   Очистка /var/lib/docker buildkit..."
                    sudo rm -rf /var/lib/docker/buildkit/* 2>/dev/null || true
                fi
                
                echo -e "   ${GREEN}DOCKER УНИЧТОЖЕН!${NC}"
            else
                echo "   Отменено"
            fi
            ;;
        0)
            echo "   Пропущено"
            return
            ;;
    esac
    
    echo ""
    print_step "После очистки:"
    sudo docker system df 2>/dev/null || true
}

cleanup_system() {
    print_header "SYSTEM [AGGRESSIVE]"
    
    print_step "Агрессивная очистка журналов (оставляем 3 дня)..."
    local journal_before
    journal_before=$(sudo du -sb /var/log/journal 2>/dev/null | cut -f1 || echo 0)
    sudo journalctl --vacuum-time=3d --quiet
    sudo journalctl --vacuum-size=100M --quiet
    local journal_after
    journal_after=$(sudo du -sb /var/log/journal 2>/dev/null | cut -f1 || echo 0)
    add_freed $((journal_before - journal_after))
    
    print_step "Удаление всех coredumps..."
    if [[ -d "/var/lib/systemd/coredump" ]]; then
        local coredump_size
        coredump_size=$(sudo du -sb /var/lib/systemd/coredump 2>/dev/null | cut -f1 || echo 0)
        sudo rm -rf /var/lib/systemd/coredump/*
        add_freed $coredump_size
    fi
    
    print_step "Очистка старых логов..."
    sudo find /var/log -type f -name "*.gz" -delete 2>/dev/null || true
    sudo find /var/log -type f -name "*.old" -delete 2>/dev/null || true
    sudo find /var/log -type f -name "*.[0-9]" -delete 2>/dev/null || true
    sudo find /var/log -type f -name "*.log" -size +50M -exec truncate -s 0 {} \; 2>/dev/null || true
    
    print_step "Очистка thumbnail cache..."
    if [[ -d "$HOME/.cache/thumbnails" ]]; then
        local thumb_size
        thumb_size=$(get_size "$HOME/.cache/thumbnails")
        safe_rm "$HOME/.cache/thumbnails"/*
        add_freed $thumb_size
    fi
    
    print_step "Агрессивная очистка ~/.cache..."
    local cache_before
    cache_before=$(get_size "$HOME/.cache")
    
    local keep_caches=("paru")
    
    for dir in "$HOME/.cache"/*; do
        if [[ -d "$dir" ]]; then
            local name
            name=$(basename "$dir")
            local keep=false
            
            for k in "${keep_caches[@]}"; do
                if [[ "$name" == "$k" ]]; then
                    keep=true
                    break
                fi
            done
            
            [[ "$keep" == false ]] && safe_rm "$dir"
        fi
    done
    
    local cache_after
    cache_after=$(get_size "$HOME/.cache")
    add_freed $((cache_before - cache_after))
    
    print_step "Очистка корзины..."
    if [[ -d "$HOME/.local/share/Trash" ]]; then
        local trash_size
        trash_size=$(get_size "$HOME/.local/share/Trash")
        safe_rm "$HOME/.local/share/Trash"/*
        add_freed $trash_size
    fi
    
    print_step "Очистка временных файлов..."
    sudo find /tmp -type f -atime +1 -delete 2>/dev/null || true
    sudo find /var/tmp -type f -atime +3 -delete 2>/dev/null || true
    
    print_step "Проверка старых ядер..."
    local current_kernel
    current_kernel=$(uname -r)
    echo "   Текущее ядро: $current_kernel"
    
    local installed_kernels
    installed_kernels=$(pacman -Q | grep -E "^linux[0-9]*(-lts|-zen|-hardened)?\s" | grep -v headers || true)
    if [[ -n "$installed_kernels" ]]; then
        echo "   Установленные ядра:"
        echo "$installed_kernels" | sed 's/^/   /'
    fi
    
    print_step "Пересоздание font cache..."
    safe_rm "$HOME/.cache/fontconfig"/* 2>/dev/null || true
    fc-cache -f 2>/dev/null || true
}

nuclear_clean() {
    echo -e "${RED}"
    echo "╔═══════════════════════════════════════════════════════╗"
    echo "║                    ☢ ЯДЕРНАЯ ОЧИСТКА ☢                ║"
    echo "║                                                       ║"
    echo "║  Это удалит ВСЕ кэши, build директории, LSP серверы,  ║"
    echo "║  Docker данные, VS Code кэши и временные файлы.       ║"
    echo "║                                                       ║"
    echo "║  После этого потребуется:                            ║"
    echo "║  • Перекомпиляция Rust/Java проектов                 ║"
    echo "║  • Переустановка node_modules (bun install)          ║"
    echo "║  • Скачивание LSP серверов (при открытии editors)    ║"
    echo "║  • Пересборка Docker образов                         ║"
    echo "║  • Переиндексация IDE workspace                      ║"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    read -p "Введите 'NUKE IT' для запуска: " confirm
    
    if [[ "$confirm" != "NUKE IT" ]]; then
        echo "Отменено"
        return
    fi
    
    echo ""
    echo -e "${MAGENTA}ЗАПУСК ЯДЕРНОЙ ОЧИСТКИ...${NC}"
    echo ""
    
    cleanup_pacman
    cleanup_rust
    cleanup_java
    cleanup_intellij
    cleanup_bun
    cleanup_neovim
    cleanup_vscode
    cleanup_zed
    cleanup_docker
    cleanup_system
}

disk_report() {
    print_header "ОТЧЁТ О ДИСКЕ"
    
    echo -e "${CYAN}Использование разделов:${NC}"
    df -h / /home 2>/dev/null | tail -n +2
    
    echo -e "\n${CYAN}Топ-15 директорий в HOME:${NC}"
    du -h --max-depth=1 "$HOME" 2>/dev/null | sort -hr | head -15
    
    echo -e "\n${CYAN}Большие скрытые директории:${NC}"
    du -h --max-depth=1 "$HOME"/.[!.]* 2>/dev/null | sort -hr | head -15
    
    echo -e "\n${CYAN}Потенциально очищаемое:${NC}"
    
    local potential=0
    
    local check_dirs=(
        "$HOME/.cargo:~/.cargo"
        "$HOME/.rustup:~/.rustup"
        "$HOME/.m2:~/.m2"
        "$HOME/.gradle:~/.gradle"
        "$HOME/.cache:~/.cache"
        "$HOME/.local/share/nvim:~/.local/share/nvim"
        "$HOME/.config/Code - OSS:~/.config/Code - OSS"
        "$HOME/.config/Code:~/.config/Code"
        "$HOME/.config/JetBrains:~/.config/JetBrains"
        "$HOME/.local/share/JetBrains:~/.local/share/JetBrains"
    )
    
    for entry in "${check_dirs[@]}"; do
        local dir="${entry%%:*}"
        local display="${entry##*:}"
        if [[ -d "$dir" ]]; then
            local size
            size=$(get_size "$dir")
            echo "   $display: $(human_readable $size)"
            potential=$((potential + size))
        fi
    done
    
    if [[ -d "/var/lib/docker" ]]; then
        local size
        size=$(sudo du -sb /var/lib/docker 2>/dev/null | cut -f1 || echo 0)
        echo "   /var/lib/docker: $(human_readable $size)"
    fi
    
    echo ""
    echo -e "${YELLOW}Потенциально освобождаемо: $(human_readable $potential)${NC}"
}

show_help() {
    echo -e "${CYAN}Arch Linux Aggressive Cleanup Script v${SCRIPT_VERSION}${NC}"
    echo ""
    echo "Использование: $0 [ОПЦИИ]"
    echo ""
    echo "Опции:"
    echo "  -h, --help        Показать эту справку"
    echo "  -v, --version     Показать версию"
    echo "  -a, --all         Полная агрессивная очистка"
    echo "  -n, --nuclear     Ядерная очистка (всё без вопросов)"
    echo "  -r, --report      Отчёт о диске (ничего не удаляет)"
    echo "  --pacman          Только pacman/paru"
    echo "  --rust            Только Rust/Cargo"
    echo "  --java            Только Java/Maven/Gradle"
    echo "  --intellij        Только IntelliJ IDEA"
    echo "  --node            Только Bun/NPM/Node"
    echo "  --nvim            Только Neovim"
    echo "  --vscode          Только VS Code"
    echo "  --zed             Только Zed"
    echo "  --docker          Только Docker"
    echo "  --system          Только системная очистка"
    echo ""
    echo "Примеры:"
    echo "  $0                # Интерактивный режим"
    echo "  $0 --all          # Полная очистка"
    echo "  $0 --rust --java  # Только Rust и Java"
    echo "  $0 --report       # Только отчёт"
}

main() {
    if [[ $# -eq 0 ]]; then
        echo -e "${RED}"
        echo "╔═══════════════════════════════════════════════════════╗"
        echo "║     ☢ ARCH LINUX AGGRESSIVE CLEANUP SCRIPT ☢         ║"
        echo "║                                                       ║"
        echo "║  pacman/paru + Rust + Java + Bun + Neovim + VS Code  ║"
        echo "║            + Zed + IntelliJ IDEA + Docker            ║"
        echo "║                                                       ║"
        echo "║                   v${SCRIPT_VERSION}                           ║"
        echo "╚═══════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        echo "Режим очистки:"
        echo ""
        echo -e "  ${GREEN}1)${NC} Полная агрессивная очистка (всё по очереди)"
        echo -e "  ${RED}2)${NC} ☢ ЯДЕРНАЯ ОЧИСТКА (удалить ВСЁ без вопросов)"
        echo ""
        echo "  3) Pacman / Paru"
        echo "  4) Rust / Cargo"
        echo "  5) Java (Maven/Gradle)"
        echo "  6) IntelliJ IDEA"
        echo "  7) Bun / NPM / Node"
        echo "  8) Neovim"
        echo "  9) VS Code"
        echo "  10) Zed"
        echo "  11) Docker"
        echo "  12) Система"
        echo ""
        echo "  13) Отчёт о диске (ничего не удаляет)"
        echo "  0) Выход"
        echo ""
        read -p "Выбор [1]: " choice
        choice=${choice:-1}
        
        case $choice in
            1)
                cleanup_pacman
                cleanup_rust
                cleanup_java
                cleanup_intellij
                cleanup_bun
                cleanup_neovim
                cleanup_vscode
                cleanup_zed
                cleanup_docker
                cleanup_system
                ;;
            2) nuclear_clean ;;
            3) cleanup_pacman ;;
            4) cleanup_rust ;;
            5) cleanup_java ;;
            6) cleanup_intellij ;;
            7) cleanup_bun ;;
            8) cleanup_neovim ;;
            9) cleanup_vscode ;;
            10) cleanup_zed ;;
            11) cleanup_docker ;;
            12) cleanup_system ;;
            13) disk_report; exit 0 ;;
            0) exit 0 ;;
            *) print_error "Неверный выбор"; exit 1 ;;
        esac
    else
        while [[ $# -gt 0 ]]; do
            case $1 in
                -h|--help)
                    show_help
                    exit 0
                    ;;
                -v|--version)
                    echo "v${SCRIPT_VERSION}"
                    exit 0
                    ;;
                -a|--all)
                    cleanup_pacman
                    cleanup_rust
                    cleanup_java
                    cleanup_intellij
                    cleanup_bun
                    cleanup_neovim
                    cleanup_vscode
                    cleanup_zed
                    cleanup_docker
                    cleanup_system
                    shift
                    ;;
                -n|--nuclear)
                    nuclear_clean
                    shift
                    ;;
                -r|--report)
                    disk_report
                    exit 0
                    ;;
                --pacman) cleanup_pacman; shift ;;
                --rust) cleanup_rust; shift ;;
                --java) cleanup_java; shift ;;
                --intellij) cleanup_intellij; shift ;;
                --node) cleanup_bun; shift ;;
                --nvim) cleanup_neovim; shift ;;
                --vscode) cleanup_vscode; shift ;;
                --zed) cleanup_zed; shift ;;
                --docker) cleanup_docker; shift ;;
                --system) cleanup_system; shift ;;
                *)
                    print_error "Неизвестная опция: $1"
                    show_help
                    exit 1
                    ;;
            esac
        done
    fi
    
    print_header "ИТОГО"
    echo -e "${GREEN}═════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}   ОСВОБОЖДЕНО: $(human_readable $FREED_SPACE)${NC}"
    echo -e "${GREEN}═════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Использование диска:"
    df -h / | tail -1
}

trap 'print_error "Скрипт прерван"; exit 130' INT TERM

main "$@"
