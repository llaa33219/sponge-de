# sponge-de build target — Qt6 Widgets component (Phase 3).
#
# Qt components are built by qmake, not by the normal Genode SRC_CC
# mechanism. The build glue lives in import-qt6_qmake.mk, pulled in
# via the qt6_qmake dummy library. See mixer_gui_qt6 in the Genode
# gems repo for the reference pattern.
#
# Pattern B bootstrap: sponge-de provides its own Libc::Component::construct
# (it needs Genode::Env for future ROM/Report sessions), so the
# qt6_component auto-bootstrap lib is disabled via QT6_COMPONENT_LIB_SO=.

QMAKE_PROJECT_FILE = $(PRG_DIR)/sponge_de.pro

QMAKE_TARGET_BINARIES = sponge-de

# Shared umbrella-owned header/source locations, resolved across Genode
# REPOSITORIES via select_from_repositories (no ../../ assumptions).
# select_parent_dir strips the trailing slash before deriving again:
# $(dir) alone is idempotent on slash-terminated strings, so a bare
# $(dir $(dir ...)) would not move up. The parent of the selected file
# is exported to the qmake run; sponge_de.pro consumes the results as
# SPONGE_SHARED_INCLUDE_DIR / SPONGE_BACKEND_CLIENT_DIR.
select_parent_dir = $(patsubst %/,%,$(dir $(1)))
SPONGE_SHARED_INCLUDE_DIR := $(call select_parent_dir,$(call select_parent_dir,$(call select_from_repositories,include/sponge/backend_client.h)))
SPONGE_BACKEND_CLIENT_DIR := $(call select_parent_dir,$(call select_from_repositories,lib/src/sponge_backend_client/backend_client.cc))
export SPONGE_SHARED_INCLUDE_DIR
export SPONGE_BACKEND_CLIENT_DIR

QT6_PORT_LIBS = libQt6Core libQt6Gui libQt6Widgets

LIBS = qt6_qmake base libc libm mesa stdcxx qt6_component

QT6_COMPONENT_LIB_SO =

QT6_GENODE_LIBS_APP += ld.lib.so
qmake_prepared.tag: $(addprefix build_dependencies/lib/,$(QT6_GENODE_LIBS_APP))
