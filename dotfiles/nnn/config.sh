#! /bin/sh

# ╔════════════════════════════════════════════════════════════════════════╗
# ║ Plugins                                                                ║
# ╚════════════════════════════════════════════════════════════════════════╝

# NNN uses the file pointed at `NNN_FIFO` to tell plugins which file is
# currently hovered. 
export NNN_FIFO="${XDG_RUNTIME_DIR}/nnn.fifo"

# ╔════════════════════════════════════════════════════════════════════════╗
# ║ Color config                                                           ║
# ╚════════════════════════════════════════════════════════════════════════╝

BLK="0B"
CHR="0B"
DIR="03"
EXE="01"
REG="00"
HARDLINK="06"
SYMLINK="06"
MISSING="00"
ORPHAN="09"
FIFO="06"
SOCK="0B"
OTHER="06"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
