## 2022.09.16

## zsh installation

```bash
$ yay -S zsh
```

## oh-my-zsh installation

From the official site of the `oh-my-zsh`, we got this command:

```bash
$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
```

```bash
$ wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
```

## plugins configuration

- auto-suggestions

    ```bash
    $ git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ```

- syntax-highlighting

    ```bash
    $ git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    ```

- vi-mode
    ```bash
    $ git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
    ```

Use `.zshrc` to replace the `~/.zshrc`.
