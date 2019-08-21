
# which gcc compiler to use for compiling freedom-bin2hex
HOST_PREFIX ?=
EXEC_SUFFIX ?=

# where to install all the artifacts of a freedom-elf2hex build
INSTALL_PATH ?=

# which cross compiler toolchain to reference for the objcopy tool
TARGET_PREFIX ?= riscv64-unknown-elf-

# toolchain path - if any - optional extra path string for the objcopy tool
TOOLCHAIN_PATH ?=

.PHONY: all install
all: util/freedom-bin2hex$(EXEC_SUFFIX) bin/bin2hex bin/elf2hex bin/elf2bin

util/freedom-bin2hex$(EXEC_SUFFIX): util/freedom-bin2hex.c
	$(HOST_PREFIX)gcc -std=c99 -o $@ $<

bin/bin2hex: bin/freedom-bin2hex.sh
	cat $< > $@
	chmod +x $@

bin/elf2hex: bin/freedom-elf2hex.sh
	cat $< | sed 's:X_TARGET_PREFIX_X:$(TARGET_PREFIX):g' | sed 's:X_TOOLCHAIN_PATH_X:$(TOOLCHAIN_PATH):g' > $@
	chmod +x $@

bin/elf2bin: bin/freedom-elf2bin.sh
	cat $< | sed 's:X_TARGET_PREFIX_X:$(TARGET_PREFIX):g' | sed 's:X_TOOLCHAIN_PATH_X:$(TOOLCHAIN_PATH):g' > $@
	chmod +x $@

install: util/freedom-bin2hex$(EXEC_SUFFIX) bin/bin2hex bin/elf2hex bin/elf2bin
	rm -rf $(INSTALL_PATH)/util/freedom-bin2hex$(EXEC_SUFFIX)
	mkdir -p $(INSTALL_PATH)/util
	cp util/freedom-bin2hex$(EXEC_SUFFIX) $(INSTALL_PATH)/util/freedom-bin2hex$(EXEC_SUFFIX)
	rm -rf $(INSTALL_PATH)/bin/$(TARGET_PREFIX)bin2hex
	rm -rf $(INSTALL_PATH)/bin/$(TARGET_PREFIX)elf2hex
	rm -rf $(INSTALL_PATH)/bin/$(TARGET_PREFIX)elf2bin
	mkdir -p $(INSTALL_PATH)/bin
	cp bin/bin2hex $(INSTALL_PATH)/bin/$(TARGET_PREFIX)bin2hex
	cp bin/elf2hex $(INSTALL_PATH)/bin/$(TARGET_PREFIX)elf2hex
	cp bin/elf2bin $(INSTALL_PATH)/bin/$(TARGET_PREFIX)elf2bin

clean:
	rm -rf util/freedom-bin2hex$(EXEC_SUFFIX) bin/bin2hex bin/elf2hex bin/elf2bin
