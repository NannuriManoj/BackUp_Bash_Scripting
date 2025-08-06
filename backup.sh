#!/bin/bash

# ==== Configuration ====
BACKUP_ROOT="C:/Users/user/OneDrive/Documents/Backup_files"
LOGFILE="$BACKUP_ROOT/backup.txt"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$BACKUP_ROOT/backup_$TIMESTAMP"
COMPRESS=false
FILES=()

for arg in "$@"; do
  if [[ "$arg" == "--compress" ]]; then
    COMPRESS=true
  elif [[ -f "$arg" ]]; then
    cp "$arg" "$BACKUP_DIR"
    echo "Backed up: $arg" >> "$LOGFILE"
  else
    echo "Warning: '$arg' is not a valid file or option." >> "$LOGFILE"
  fi
done


# ==== Compress if --compress is used ====
if $COMPRESS; then
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  ARCHIVE_NAME="$BACKUP_DIR-$TIMESTAMP.tar.gz"
  tar -czf "$ARCHIVE_NAME" -C "$BACKUP_ROOT" "$(basename "$BACKUP_DIR")"
  rm -r "$BACKUP_DIR"
  echo "Compressed backup saved to $ARCHIVE_NAME" >> "$LOGFILE"
else
  echo "Backup folder created at $BACKUP_DIR" >> "$LOGFILE"
fi


# ==== Log Summary ====
echo "Backup done at: $(date)" >> "$LOGFILE"
echo "Files: ${FILES[*]}" >> "$LOGFILE"
echo "--------------------------" >> "$LOGFILE"

echo "Backup completed successfully."
