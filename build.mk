#
# Author(s): Enrico Weigelt, metux IT services <weigelt@metux.de>
#

VERSION=1.0.2
PREFIX?=/usr
LIBDIR?=$(PREFIX)/lib
INCLUDEDIR?=$(PREFIX)/include
PKGCONFIGDIR?=$(LIBDIR)/pkgconfig
AR?=ar
RANLIB?=ranlib

PKG_CONFIG?=pkg-config
PKG_CONFIG_PATH?=$(SYSROOT)$(PKGCONFIGDIR)

MIXP_LIBS?=`$(PKG_CONFIG) --libs libmixp`
MIXP_CFLAGS?=`$(PKG_CONFIG) --cflags libmixp`

HASH_LIBS=-lhash
HASH_CFLAGS=

CFLAGS+=$(MIXP_CFLAGS)
LDFLAGS+=$(MIXP_LIBS)

%.pc:		%.pc.in
	cat $< | \
	    sed -e 's~@VERSION@~$(VERSION)~'       | \
	    sed -e 's~@PREFIX@~$(PREFIX)~'         | \
	    sed -e 's~@LIBDIR@~$(LIBDIR)~'         | \
	    sed -e 's~@INCLUDEDIR@~$(INCLUDEDIR)~' > $@

%.a:
	$(AR) cr $@ $^ && $(RANLIB) $@

#%.so:
#	$(LD) -o $@ -soname lib$(SONAME) -shared $^

#%.so:
#	$(LD) -o $@ -lc $(LDFLAGS) -no-undefined -shared -soname $(SONAME) $^ $(LIBC_LIBS)

%.so:
	$(LD) -o $@ -lc $(LDFLAGS) -no-undefined -shared $^ $(LIBC_LIBS)

%.nopic.o:	%.c
	$(CC) -o $@ -c $< $(CFLAGS)

%.pic.o:	%.c
	$(CC) -fpic -o $@ -c $< $(CFLAGS)

%.uno:	%.c
	uno -w -t -u -o $@ -c $< $(CFLAGS)

dump:
	@echo PREFIX=$(PREFIX)
	@echo PKG_CONFIG_PATH=$(PKG_CONFIG_PATH)
	@echo MIXP_LDFLAGS=$(MIXP_LDFLAGS)
	@echo MIXP_CFLAGS=$(MIXP_CFLAGS)
