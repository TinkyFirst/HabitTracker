#!/bin/bash

# Скрипт для перевірки App Icon на прозорість
# Використання: ./check_app_icons.sh

echo ""
echo "========================================================================"
echo "🔍 ПЕРЕВІРКА APP ICON НА ПРОЗОРІСТЬ (ALPHA CHANNEL)"
echo "========================================================================"
echo ""

# Знаходимо Assets.xcassets
ASSETS_PATH=$(find . -name "Assets.xcassets" -type d | head -1)

if [ -z "$ASSETS_PATH" ]; then
    echo "❌ Не знайдено Assets.xcassets"
    echo "💡 Запустіть цей скрипт з кореневої папки проекту"
    exit 1
fi

echo "📂 Знайдено Assets: $ASSETS_PATH"

# Шукаємо AppIcon.appiconset
APPICON_PATH="$ASSETS_PATH/AppIcon.appiconset"

if [ ! -d "$APPICON_PATH" ]; then
    echo "❌ Не знайдено AppIcon.appiconset"
    exit 1
fi

echo "📱 Перевірка іконок у: $APPICON_PATH"
echo ""

# Лічильники
TOTAL=0
WITH_ALPHA=0
WITHOUT_ALPHA=0

# Перевіряємо всі PNG файли
for file in "$APPICON_PATH"/*.png; do
    if [ -f "$file" ]; then
        TOTAL=$((TOTAL + 1))
        FILENAME=$(basename "$file")
        
        # Перевіряємо alpha channel
        HAS_ALPHA=$(sips -g hasAlpha "$file" 2>/dev/null | grep "hasAlpha" | awk '{print $2}')
        
        if [ "$HAS_ALPHA" == "yes" ]; then
            echo "⚠️  $FILENAME - HAS ALPHA CHANNEL (потрібно видалити!)"
            WITH_ALPHA=$((WITH_ALPHA + 1))
        else
            echo "✅ $FILENAME - no alpha channel"
            WITHOUT_ALPHA=$((WITHOUT_ALPHA + 1))
        fi
    fi
done

echo ""
echo "========================================================================"
echo "📊 РЕЗУЛЬТАТИ:"
echo "   Всього файлів: $TOTAL"
echo "   ✅ Без alpha: $WITHOUT_ALPHA"
echo "   ⚠️  З alpha: $WITH_ALPHA"
echo "========================================================================"

if [ $WITH_ALPHA -gt 0 ]; then
    echo ""
    echo "❌ ПРОБЛЕМА: Деякі іконки мають alpha channel!"
    echo ""
    echo "🔧 ЯК ВИПРАВИТИ:"
    echo "1. Згенеруйте нові іконки через AppIconGenerator.generateAndSaveIcons()"
    echo "2. Або використайте команду для видалення alpha з існуючих:"
    echo ""
    echo "   cd \"$APPICON_PATH\""
    echo "   for file in *.png; do"
    echo "     sips -s format jpeg \"\$file\" --out temp.jpg"
    echo "     sips -s format png temp.jpg --out \"\$file\""
    echo "     rm temp.jpg"
    echo "   done"
    echo ""
    exit 1
else
    echo ""
    echo "✅ ВСІ ІКОНКИ ПРАВИЛЬНІ! Alpha channel відсутній."
    echo ""
    exit 0
fi
