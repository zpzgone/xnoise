NULL =

SUBDIRS =  \
    $(NULL)

DIST_SUBDIRS =  \
    azlyrics \
    chartlyrics \
    databaseLyrics \
    lastfm \
    lyricwiki \
    magnatune \
    mediakeys \
    mpris \
    mpris_one \
    soundmenu2 \
    testplugin \
    titleToDecoration \
    ubuntuone \
    $(NULL)

if ENABLE_AZLYRICS
    SUBDIRS += azlyrics
endif

if ENABLE_CHARTLYRICS
    SUBDIRS += chartlyrics
endif

SUBDIRS += databaseLyrics

if ENABLE_LASTFM
    SUBDIRS += lastfm
endif

if ENABLE_LYRICWIKI
    SUBDIRS += lyricwiki
endif

if ENABLE_MAGNATUNE_MUSICSTORE
    SUBDIRS += magnatune
endif

if ENABLE_MEDIAKEYS
    SUBDIRS += mediakeys
endif

if ENABLE_MPRIS
    SUBDIRS += mpris
    SUBDIRS += mpris_one
endif

if ENABLE_SOUNDMENU
    SUBDIRS += soundmenu2
endif

SUBDIRS += testplugin
SUBDIRS += titleToDecoration

if ENABLE_UBUNTUONE_MUSICSTORE
    SUBDIRS += ubuntuone
endif

DISTCLEANFILES = \
    Makefile.in \
    $(NULL)


