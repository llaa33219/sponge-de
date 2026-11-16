# Sponge DE qmake project file.
#
# Links only the Qt modules actually used (AGENTS.md §3.4: minimize Qt
# dependencies). Phase 3 needs Core, Gui, and Widgets only.

QT       += core gui widgets
TEMPLATE  = app
TARGET    = sponge-de
CONFIG   += c++2a

# The cproc/qt6_api port (issue5854_2) enables the 'permissions' feature in
# mkspecs/modules/qt_lib_core.pri but does not ship mkspecs/features/
# permissions.prf, so qmake aborts at qt.prf with "Cannot find feature
# permissions". The feature is only relevant to Apple/Android packaging;
# dropping it is harmless for a Genode component.
QT_CONFIG -= permissions

# Shared umbrella-owned header/source locations. target.mk resolves
# them across Genode REPOSITORIES ($(call select_from_repositories,...))
# and exports the parent directories; the $$(...) fallback reads the
# environment for standalone qmake runs.
isEmpty(SPONGE_SHARED_INCLUDE_DIR): SPONGE_SHARED_INCLUDE_DIR = $$(SPONGE_SHARED_INCLUDE_DIR)
isEmpty(SPONGE_BACKEND_CLIENT_DIR): SPONGE_BACKEND_CLIENT_DIR = $$(SPONGE_BACKEND_CLIENT_DIR)
isEmpty(SPONGE_SHARED_INCLUDE_DIR)|isEmpty(SPONGE_BACKEND_CLIENT_DIR): \
    error("SPONGE_SHARED_INCLUDE_DIR/SPONGE_BACKEND_CLIENT_DIR must be set (target.mk exports them via select_from_repositories)")

# $$PWD            — component-root includes ("theme/theme_loader.h", ...)
# $$SPONGE_SHARED_INCLUDE_DIR — Sponge shared headers (<sponge/version.h>,
#                       <sponge/backend_client.h>)
# $$SPONGE_BACKEND_CLIENT_DIR — shared Report/ROM client
#     source compiled directly into sponge-de (qmake simplicity; the
#     same sources are also packaged as the sponge_backend_client.lib.a
#     used by vct and other plain Genode components).
INCLUDEPATH += $$PWD \
               $$SPONGE_SHARED_INCLUDE_DIR \
               $$SPONGE_BACKEND_CLIENT_DIR

SOURCES  += main.cc \
            sponge_de_main.cc \
            panel/panel_widget.cc \
            panel/panel_collection.cc \
            panel/notifier_widget.cc \
            panel/notifier_controller.cc \
            panel/notify_poster.cc \
            panel/tasklist_widget.cc \
            panel/tasklist_controller.cc \
            launcher/launcher_controller.cc \
            rom/optional_rom_dataspace.cc \
            launcher/launcher_menu_view.cc \
            theme/theme_loader.cc \
            theme/theme_controller.cc \
            config/config_controller.cc \
            config/shortcut_controller.cc \
            config/dismisser.cc \
            settings/quick_menu_controller.cc \
            background/background_widget.cc \
            background/background_controller.cc \
            background/show_desktop.cc \
            $$SPONGE_BACKEND_CLIENT_DIR/backend_client.cc

HEADERS  += sponge_de_main.h \
            panel/panel_widget.h \
            panel/panel_collection.h \
            panel/notifier_widget.h \
            panel/notifier_controller.h \
            panel/notify_poster.h \
            panel/tasklist_widget.h \
            panel/tasklist_controller.h \
            panel/task_info.h \
            launcher/launcher_controller.h \
            rom/optional_rom_dataspace.h \
            launcher/launcher_menu_view.h \
            theme/theme_loader.h \
            theme/theme_qt.h \
            theme/theme_controller.h \
            config/config_controller.h \
            config/shortcut_controller.h \
            config/dismisser.h \
            settings/quick_menu_controller.h \
            background/background_widget.h \
            background/background_controller.h \
            background/show_desktop.h
