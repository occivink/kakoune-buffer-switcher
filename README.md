# kakoune-buffer-switcher

[Kakoune](http://kakoune.org) plugin to navigate between open buffers, and manipulate the buffers-list.

## Setup

Add `buffer-switcher.kak` to your `autoload` directory: `~/.config/kak/autoload/`, or source it manually.

This plugin relies on a (yet unreleased) [commit](https://github.com/mawww/kakoune/commit/09375edf546dc2845960adb718db28bdcb220df1) in kakoune.

## Usage

This plugin can be used with the `buffer-switcher` command. When it is invoked, a special-purpose `*buffer-switcher*` buffer is created. It lists all currently opened buffers (except for itself and `*debug*`), one per line.  
Pressing `<ret>` will change the current buffer to the one under the cursor, and close the switcher. In addition, if a line was removed its buffer is removed as well (unless it has unsaved changes). The remaining buffers are re-ordered according to the order of the lines.  
Pressing `<esc>` will close the switcher, without applying any of the changes.

Note: the experience is likely suboptimal when using multiple clients, suggestions for improvements on that front are welcome.

## Customization

The face `BufferSwitcherCurrent` is used to indicate the buffer that was previously active.

## License

[Unlicense](http://unlicense.org)
