

pandoc index.md -s -o index.html
pandoc privacy.md -s -o privacy.html
pandoc term.md -s -o term.html


echo ""
echo "========== TODO ========="
echo "フォントファミリーを sans-serif  に変更すること"
echo "そのあとでファイルを../publicに移動させてデプロイすること"
echo ""
