# zsh

My ZSH config is designed to be completely no-compromises: fast, minimal, and easily extensible with all the features of a modern terminal. This config suports interoperability with Oh-My-ZSH themes and plugins out of the box, and uses the same simple config options found in OMZ.

#### Features (out of the box):
- Custom plugin manager
- Autosuggestions ([zsh-autosuggestions](https://github.caom/zsh-users/zsh-autosuggestions))
- Syntax hightlighting ([zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)) 
- Custom prompt with git status and exit code 
- Command line history searching ([fzf](https://github.com/junegunn/fzf))
- Icons for `ls` ([exa](https://github.com/ogham/exa))

### Installation
  
To easily install this config you can run the install script through the following command. You can also install manually
  
```sh
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/jswent/zsh/main/install.zsh)"
```
#### Manual inspection

It's good practice to inspect any script you download from any source you don't know, you can do that by downloading the installation script as a file 
and opening in your preferred text editor. 

```sh 
wget https://raw.githubusercontent.com/jswent/zsh/main/install.zsh
nvim install.zsh
chmod +x install.zsh
./install.zsh
```
### Usage

Below are some useful hotkeys and aliases to get going with this configuration. If you wish to modify any of these settings or add your own pelase see the below [Configuration](#Configuration) section 

| Keybind                          | Description                                                 |
| :------------------------------- | :---------------------------------------------------------- |
| <Ctrl+r>                         | Opens fzf command-line autocomplete menu                    |
| <Ctrl+Space>                     | Finish current command-line completion                      |
| <Ctrl+f>                         | Opens ranger file manager in current working directory      |

| Alias                            | Description                                                 |
| :------------------------------- | :---------------------------------------------------------- |
| ggs                              | `git status`                                                |
| gga                              | `git add`                                                   |
| ggc                              | `git commit -m`                                             |
| ggp                              | Function which pushes current branch to all remote branches |

### Configuration

This configuration contains various tools useful for my workflow, however that might not be the case for everyone. If after your installation you wish to change some of the various configuration options please refer to this guide.

#### Plugins 

The plugins used in this configuration are stored in the `$ZSH/plugins` directory and can also be sourced automatically from supported Oh-My-ZSH plugins. The default plugins used in this configuration are as follows:

| Plugin                           | Description                                                                                    |
| :------------------------------- | :--------------------------------------------------------------------------------------------- |
| **zsh-autosuggestions**          | Fish-like command line autosuggestions (accept suggestion with Ctrl+Space)                     |
| **zsh-syntax-highlighting**      | Fish-like command line syntax highlighting                                                     |
| **fzf**                          | FZF command-line history fuzzy searching                                                       |
| **git-prompt.zsh**               | Provides the git prompt for the `custom` theme (this can be disabled if using alternate theme) | 
| **nvm.plugin.zsh**               | Provides support for [nvm](https://github.com/nvm-sh/nvm)                                      |
| **theme-change.zsh**             | Allows you to quickly change your selected theme                                               | 

##### Plugin Manager 

This configuration uses a custom plugin manager (found at `$ZSH/plugins/zpm.zsh`) which will abstract over the task of sourcing plugins, all while avoiding the bloat of Oh-My-ZSH.

To add or remove a plugin, simply add or remove the desired plugin from the `plugins` variable found in `.zshrc` (seen below)

```sh 
## SELECT PLUGINS
export plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
  nvm 
  git-prompt
  fzf
  #navi-plugin  -- To disable a plugin simply comment it out or remove it from the list
  theme-change
  any OMZ plugin...
)
```

#### Snippets

Similar to the plugins section above, the snippets used to customize the above plugins can be found in the `$ZSH/snippets/` directory. These snippets are essential to the correct functionality of the config so please be careful if you don't know what you're doing.

| Snippet                  | Description                                              |
| :---------------------- | :------------------------------------------------------- |
| **path.zsh**     | Specifies additions to `$PATH`, edit according to your use case                                    |
| **prompt.zsh**   | Custom ZSH prompt that will be used if no theme provided, will not be sourced if theme specified.                                             |
| **pyenv.zsh** | Provides [pyenv](https://github.com/pyenv/pyenv) integration with ZSH                        |
| **theme.zsh**       | Sources theme specified in `.zsh` **(DO NOT REMOVE!!)** |
| **tmux-autoreload.zsh** | Uses [entr](https://github.com/eradman/entr) to reload tmux configuration file if there are any changes (disable if you will not be using tmux)

##### Snippet Manager 

A similar `snippets` variable exists in `.zshrc` which is where you can specify what snippets you wish to use. For example, if you wish to disable a plugin please disable the corresponding snippet. This will likely not cause any errors, but sourcing unrequired files will add unnecessary startup time.


