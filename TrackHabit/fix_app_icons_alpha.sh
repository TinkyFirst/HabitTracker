#!/bin/bash

# Скрипт для АВТОМАТИЧНОГО видалення alpha channel з App Icon
# ⚠️  УВАГА: Цей скрипт ЗМІНЮЄ файли на місці!
# Використання: ./fix_app_icons_alpha.sh

echo ""
echo "========================================================================"
echo "🔧 АВТОМАТИЧНЕ ВИДАЛЕННЯ ALPHA CHANNEL З APP ICON"
echo "========================================================================"
echo ""

# Знаходимо Assets.xcassets
ASSETS_PATH=$(find . -name "Assets.xcassets" -type d | head -1)

if [ -z "$ASSETS_PATH" ]; then
    echo "❌ Не знайдено Assets.xcassets"
    exit 1
fi

APPICON_PATH="$ASSETS_PATH/AppIcon.appiconset"

if [ ! -d "$APPICON_PATH" ]; then
    echo "❌ Не знайдено AppIcon.appiconset"
    exit 1
fi

echo "📱 Обробка іконок у: $APPICON_PATH"
echo ""

# Створюємо backup
BACKUP_PATH="$APPICON_PATH/../AppIcon_backup_$(date +%Y%m%d_%H%M%S).appiconset"
cp -r "$APPICON_PATH" "$BACKUP_PATH"
echo "💾 Backup створено: $BACKUP_PATH"
echo ""

FIXED=0
FAILED=0

# Обробляємо всі PNG файли
for file in "$APPICON_PATH"/*.png; do
    if [ -f "$file" ]; then
        FILENAME=$(basename "$file")
        echo "🔄 Обробка: $FILENAME"
        
        # Перевіряємо чи є alpha
        HAS_ALPHA=$(sips -g hasAlpha "$file" 2>/dev/null | grep "hasAlpha" | awk '{print $2}')
        
        if [ "$HAS_ALPHA" == "yes" ]; then
            # Конвертуємо: PNG → JPEG → PNG (видаляє alpha)
            TEMP_JPG=$(mktemp).jpg
            
            if sips -s format jpeg "$file" --out "$TEMP_JPG" 2>/dev/null; then
                if sips -s format png "$TEMP_JPG" --out "$file" 2>/dev/null; then
                    echo "   ✅ Alpha channel видалено"
                    FIXED=$((FIXED + 1))
                else
                    echo "   ❌ Помилка конвертації назад у PNG"
                    FAILED=$((FAILED + 1))
                fi
                rm -f "$TEMP_JPG"
            else
                echo "   ❌ Помилка конвертації у JPEG"
                FAILED=$((FAILED + 1))
            fi
        else
            echo "   ✓  Вже без alpha channel"
        fi
        echo ""
    fi
done

echo "========================================================================"
echo "📊 РЕЗУЛЬТАТИ:"
echo "   🔧 Виправлено: $FIXED"
echo "   ❌ Помилок: $FAILED"
echo "   💾 Backup: $BACKUP_PATH"
echo "========================================================================"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "✅ ГОТОВО! Тепер запустіть білд у Xcode (⌘+B)"
    echo ""
    echo "🗑️  Якщо все працює, видаліть backup:"
    echo "   rm -rf \"$BACKUP_PATH\""
else
    echo "⚠️  Деякі файли не вдалося обробити."
    echo "💡 Відновіть з backup якщо потрібно:"
    echo "   rm -rf \"$APPICON_PATH\""
    echo "   mv \"$BACKUP_PATH\" \"$APPICON_PATH\""
fi

echo ""
