#!/bin/sh

# https://borgbackup.readthedocs.io/en/stable/quickstart.html
REPOSITORY=username@remoteserver.com:backup

# Setting this, so you won't be asked for your repository passphrase:
# export BORG_PASSPHRASE='XYZl0ngandsecurepa_55_phrasea&&123'
# or this to ask an external program to supply the passphrase:
export BORG_PASSCOMMAND=`cat /path/to/passcommand`

# Backup all of /home and /var/www except a few
# excluded directories
borg create -v --stats --compression zlib,5     \
    $REPOSITORY::'{hostname}-{now:%Y-%m-%d}'    \

    $HOME/Documents
    $HOME/Pictures
    $HOME/Downloads

    # /home                                       \
    # /var/www                                    \
    # --exclude '/home/*/.cache'                  \
    # --exclude /home/Ben/Music/Justin\ Bieber    \
    # --exclude '*.pyc'

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machine's archives also.
borg prune -v --list $REPOSITORY --prefix '{hostname}-' \
    --keep-daily=7 --keep-weekly=4 --keep-monthly=6
