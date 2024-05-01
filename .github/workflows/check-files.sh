#!/bin/bash

MS_IME_DICTS=assets/ms-ime/*.txt
GBOARD_DICTS=assets/gboard/*.zip

all_errs=0

echo
# ▼▼▼ Check file name formats

errs=0

# For MS-IME editions
for f in $MS_IME_DICTS; do
  if [[ ! "$f" =~ ^assets/ms-ime/Ayashiy-Nipongo-Dict_v[0-9]+\.[0-9]+\.[0-9]+_MS-IME\.txt$ ]]; then
      echo "Invalid name file: $f"
      errs=$(($errs + 1))
  fi
done

# For Gboard editions
for f in $GBOARD_DICTS; do
  if [[ ! "$f" =~ ^assets/gboard/Ayashiy-Nipongo-Dict_v[0-9]+\.[0-9]+\.[0-9]+_Gboard\.zip$ ]]; then
      echo "Invalid name file: $f"
      errs=$(($errs + 1))
  fi
done

if [ $errs -eq 0 ]; then
  echo "  All dictionary files have valid names"
else
  echo "  Error: $errs file(s) have invalid names"
fi

all_errs=$(($all_errs + $errs))

# ▲▲▲ Check file name formats
echo
# ▼▼▼ Check file encoding

errs=0

# For MS-IME editions
for f in $MS_IME_DICTS; do
  if ! file -i "$f" | grep -q "charset=utf-16le"; then
      echo "Non- UTF-16 LE file: $f"
      errs=$(($errs + 1))
  fi
done

# Gboard editions are ZIP file

if [ $errs -eq 0 ]; then
  echo "  All MS-IME dictionary files are UTF-16 LE encoded"
else
  echo "  Error: $errs file(s) are not UTF-16 LE encoded"
fi

all_errs=$(($all_errs + $errs))

# ▲▲▲ Check file encoding
echo
# ▼▼▼ Check line endings

errs=0

# For MS-IME editions
for f in $MS_IME_DICTS; do
  if ! file "$f" | grep -q "CRLF"; then
      echo "Non-CRLF file: $f"
      errs=$(($errs + 1))
  fi
done

# Gboard editions are ZIP file

if [ $errs -eq 0 ]; then
  echo "  All MS-IME dictionary files have CRLF line endings"
else
  echo "  Error: $errs file(s) have non-CRLF line endings"
fi

all_errs=$(($all_errs + $errs))

# ▲▲▲ Check line endings
echo

if [ $all_errs -eq 0 ]; then
  echo " All checks passed!"
else
  echo " Error: total $all_errs error(s) found"
  exit 1
fi
