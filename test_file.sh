size=$(apt-cache --no-all-versions show firefox | grep '^Size: ' | sed 's/^Size: //')
size_in_bytes=$(numfmt --from=iec $size)
echo "Package size: $size_in_bytes bytes"