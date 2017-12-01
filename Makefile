TARGET   := $(shell basename "$(shell pwd)")

SOURCES  := .
INCLUDES := $(SOURCES)

CFLAGS   :=
CFLAGS   := $(CFLAGS) -Wall -Wextra -Os -std=gnu99
#CFLAGS   := $(CFLAGS) -flto=3 -fwhole-program -fuse-linker-plugin
CFLAGS   := $(CFLAGS) -flto=4 -fuse-linker-plugin
CFLAGS   := $(CFLAGS) -fno-stack-protector -fno-ident -fomit-frame-pointer -falign-functions=1 -falign-jumps=1 -falign-loops=1 -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-unroll-loops -fmerge-all-constants -fno-math-errno
CFLAGS   := $(CFLAGS) -Wl,--as-needed
CFLAGS   := $(CFLAGS) -DBUILD_COMMIT="\"`git rev-parse --short HEAD``git diff --shortstat --quiet || echo ' (dirty)'`\"" -DBUILD_DATE="\"`date -u +'%Y-%m-%d %H:%M:%S %Z'`\""

LIBDIR   :=
LDFLAGS  := -lm -lc

INCLUDE  += $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir))
CFILES   += $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES += $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))

OBJS     := $(CFILES:.c=.o) $(CPPFILES:.cpp=.o)
DEPENDS  := $(OBJS:.o=.d)

OUTPUT   := $(CURDIR)/bin
ELF      := $(OUTPUT)/$(TARGET)

export VPATH := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir))

GCC ?= $(CROSS_COMPILE)gcc
STRIP ?= $(CROSS_COMPILE)strip

.PHONY: all elf dir
all: elf
elf: $(ELF)

%.o:%.c Makefile
	@$(GCC) -MMD $(CFLAGS) $(INCLUDE) -c $< -o $@

%.o:%.cpp Makefile
	@$(GCC) -MMD $(CFLAGS) $(INCLUDE) -c $< -o $@

-include $(DEPENDS)

dir:
	@mkdir -p "$(OUTPUT)"

$(ELF).elf: $(OBJS) dir
	@$(GCC) $(CFLAGS) $(OBJS) $(LDFLAGS) $(LDLIBS) -o $@ && $(STRIP) --strip-all $@

$(ELF): $(ELF).elf
	@upx -qq --ultra-brute $^ -o $@ -f

clean:
	@rm -f *.o *.d
	@rm -f lodepng/*.o lodepng/*.d
