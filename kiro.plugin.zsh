# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# Plugin Name: kiro
# Description: Zsh plugin to set up environment when running in Kiro.
# Repository: https://github.com/johnstonskj/zsh-kiro-plugin
#
# Public variables:
#
# * `KIRO`; plugin-defined global associative array with the following keys:
#   * `_FUNCTIONS`; a list of all functions defined by the plugin.
#   * `_PLUGIN_DIR`; the directory the plugin is sourced from.
#   * `_PATH`; the directory for shell integration binaries.
#

############################################################################
# Standard Setup Behavior
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# See https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
declare -gA KIRO
KIRO[_PLUGIN_DIR]="${0:h}"
KIRO[_FUNCTIONS]=""

# Set the path for any custom directories here.
KIRO[_PATH]="$(kiro --locate-shell-integration-path zsh)"

############################################################################
# Internal Support Functions
############################################################################

#
# This function will add to the `KIRO[_FUNCTIONS]` list which is
# used at unload time to `unfunction` plugin-defined functions.
#
# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
# See https://wiki.zshell.dev/community/zsh_plugin_standard#the-proposed-function-name-prefixes
#
.kiro_remember_fn() {
    builtin emulate -L zsh

    local fn_name="${1}"
    if [[ -z "${KIRO[_FUNCTIONS]}" ]]; then
        KIRO[_FUNCTIONS]="${fn_name}"
    elif [[ ",${KIRO[_FUNCTIONS]}," != *",${fn_name},"* ]]; then
        KIRO[_FUNCTIONS]="${KIRO[_FUNCTIONS]},${fn_name}"
    fi
}
.kiro_remember_fn .kiro_remember_fn

############################################################################
# Plugin Unload Function
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
kiro_plugin_unload() {
    builtin emulate -L zsh

    # Remove all remembered functions.
    local plugin_fns
    IFS=',' read -r -A plugin_fns <<< "${KIRO[_FUNCTIONS]}"
    local fn
    for fn in ${plugin_fns[@]}; do
        whence -w "${fn}" &> /dev/null && unfunction "${fn}"
    done

    # Remove the global data variable.
    unset KIRO

    # Remove this function.
    unfunction kiro_plugin_unload
}

############################################################################
# Initialize Plugin
############################################################################

if [[ "${TERM_PROGRAM}" == "kiro" ]]; then
    source "${KIRO[_PATH]}"
fi

true
