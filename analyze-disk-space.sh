#!/usr/bin/env bash
echo "=== Топ пакетов по размеру в текущей системе ==="
nix path-info -S $(nix-store --query --references /run/current-system) | \
  awk '{print $2/1024/1024 " MB\t" $1}' | \
  sort -nr | \
  head -15

echo -e "\n=== Общая статистика Nix store ==="
echo "Общий размер: $(du -sh /nix/store | cut -f1)"
echo "Количество элементов: $(nix-store --query --all | wc -l)"