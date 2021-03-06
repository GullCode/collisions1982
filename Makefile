RM=rm -f
CC=gcc
EXT=

VPATH=../../LIB/src/
INCLUDE=../../LIB/include
PROGNAME=test_allegro

#CLIBS=`pkg-config --cflags --libs allegro-5 allegro_acodec-5 allegro_audio-5 allegro_color-5 allegro_dialog-5 allegro_font-5 allegro_image-5 allegro_main-5 allegro_memfile-5 allegro_physfs-5 allegro_primitives-5 allegro_ttf-5`
CLIBS=-IC:/msys64/mingw64/include -LC:/msys64/mingw64/lib -lallegro_acodec -lallegro_audio -lallegro_color -lallegro_dialog -lallegro_image -lallegro_main -lallegro_memfile -lallegro_physfs -lallegro_primitives -lallegro_ttf -lallegro_font -lallegro
LIBNILOREA=-lnilorea64

dir_name=$(shell date +%Y_%m_%d_%HH%MM%SS )

ifeq ($(OS),Windows_NT)
    CFLAGS= -I$(INCLUDE) \
-g -W -Wall -D_XOPEN_SOURCE=600 -D_XOPEN_SOURCE_EXTENTED -std=gnu99 -ggdb3 -O0 \
	    -Wno-missing-braces \
	    -Wextra \
	    -Wno-missing-field-initializers \
	    -Wswitch-default \
	    -Wswitch-enum \
	    -Wcast-align \
	    -Wpointer-arith \
	    -Wbad-function-cast \
	 #   -Wstrict-overflow=5 \
	   # -Wstrict-prototypes \
	    -Winline \
	    -Wundef \
	    -Wnested-externs \
	    -Wcast-qual \
	    -Wunreachable-code \
	    -Wlogical-op \
	    -Wstrict-aliasing=2 \
	    -Wredundant-decls \
	    -Wold-style-definition \
	#    -Werror \
	# -Werror=implicit-fallthrough=0 \
	    -fno-omit-frame-pointer \
	    -ffloat-store

	CLIBS+= -Wl,-Bstatic -lpthread -Wl,-Bdynamic -lws2_32  -L../lIB/. #-mwindows
    RM= del /Q
    CC= gcc
	ifeq (${MSYSTEM},MINGW32)
        RM=rm -f
        CFLAGS+= -m32
        EXT=.exe
        LIBNILOREA=-lnilorea32
    endif
    ifeq (${MSYSTEM},MINGW64)
        RM=rm -f
        CFLAGS+= -DARCH64BITS
        EXT=.exe
        LIBNILOREA=-lnilorea64
    endif
else
	LIBNILOREA=-lnilorea
	UNAME_S= $(shell uname -s)
	RM=rm -f
	CC=gcc
	EXT=
    ifeq ($(UNAME_S),Linux)
        CFLAGS+= -I../include \
            -g -W -Wall -D_XOPEN_SOURCE=600 -D_XOPEN_SOURCE_EXTENTED -std=gnu99 -ggdb3 -O0 \
            -Wno-missing-braces \
            -Wextra \
            -Wno-missing-field-initializers \
            -Wswitch-default \
            -Wswitch-enum \
            -Wcast-align \
            -Wpointer-arith \
            -Wbad-function-cast \
        #    -Wstrict-overflow=5 \
            -Wstrict-prototypes \
            -Winline \
            -Wundef \
            -Wnested-externs \
            -Wcast-qual \
            -Wunreachable-code \
            -Wlogical-op \
            -Wstrict-aliasing=2 \
            -Wredundant-decls \
            -Wold-style-definition \
            -Werror \
            -fno-omit-frame-pointer \
            -ffloat-store
        CLIBS+= -L../. -lpthread
    endif
    ifeq ($(UNAME_S),SunOS)
        CC=cc
        CFLAGS+= -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -g -v -xc99 -I ../include/ -mt
        CLIBS+= -lm -lsocket -lnsl -lpthread -lrt -L..
    endif
endif

SRC=n_common.c n_log.c n_str.c n_list.c n_3d.c n_time.c n_anim.c n_particles.c level.c Collision1982.c
OBJ=$(SRC:%.c=%.o)
.c.o:
	$(COMPILE.c) $<

%.o:%.c
	$(CC) $(CFLAGS) -o $@ -c $<

Collision1982$(EXT): $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(CLIBS)

all: Collision1982$(EXT)

clean:
	$(RM) *.o
	$(RM) Collision1982$(EXT)
