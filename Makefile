
# Specify target
PROJECT = fifo_8i_32o

################################################################################
# Defs
PROJ_DIR = projects
TB_EXTENSION = _tb
BUILD = build

################################################################################
# Sources
SRCS := $(shell find $(PROJ_DIR)/$(PROJECT)/ -type f -name "*.vhd")
OBJS := $(addprefix $(BUILD)/, $(notdir $(patsubst %.vhd,%.o,$(SRCS))))

TB = $(PROJECT)$(TB_EXTENSION)

################################################################################
# Executables

GHDL_COV_FLGAS = -Wc,-fprofile-arcs -Wc,-ftest-coverage
GHDL_ANALYZE = ghdl -a --workdir=.
GHDL_ELAB = ghdl -e --workdir=. -Wl,-lgcov
GHDL_RUN = ghdl -r --workdir=.

GCOV = gcov
LCOV = lcov -c --rc lcov_branch_coverage=1
GENHTML = genhtml --rc genhtml_branch_coverage=1
RM = rm -rf

################################################################################
# Output files
all: run

run: $(TB)
	cd $(BUILD)/ && $(GHDL_RUN) $(TB)
	cd $(BUILD)/ && $(GCOV) -s . $(PROJECT).vhd
	cd $(BUILD)/ && $(LCOV) -d . -o $(PROJECT)$(TB_EXTENSION).info
	cd $(BUILD)/ && $(GENHTML) -o html $(PROJECT)$(TB_EXTENSION).info

$(TB) : $(OBJS)
	cd $(BUILD)/ && $(GHDL_ELAB) $@

# GHDL_COV_FLGAS only if not tb file
cov_flags=$(if $(findstring _tb,$(1)),,$(GHDL_COV_FLGAS))
$(OBJS) : $(SRCS)
	cd $(BUILD)/ && $(GHDL_ANALYZE) $(call cov_flags,$(notdir $@)) ../$(addprefix $(PROJ_DIR)/$(PROJECT)/,$(notdir $(patsubst %.o,%.vhd,$@)))

clean:
	$(RM) $(BUILD)/*

.PHONY: all run clean
