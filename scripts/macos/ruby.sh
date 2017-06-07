#!/bin/bash

export RBENV_ROOT="$HOME/.rbenv"
export RBENV_PLUGINS="$RBENV_ROOT/plugins"

git clone https://github.com/sstephenson/rbenv.git "$RBENV_ROOT"

export PATH="$RBENV_ROOT/bin:$PATH"
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> ~/.bash_profile

eval "$(rbenv init -)"
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

cat << EOF > $RBENV_ROOT/default-gems
bundler
rubygems-bundler
EOF

mkdir -p $RBENV_PLUGINS

git clone https://github.com/sstephenson/ruby-build.git         $RBENV_PLUGINS/ruby-build
git clone https://github.com/sstephenson/rbenv-default-gems.git $RBENV_PLUGINS/rbenv-default-gems
git clone https://github.com/rkh/rbenv-whatis.git               $RBENV_PLUGINS/rbenv-whatis
git clone https://github.com/rkh/rbenv-use.git                  $RBENV_PLUGINS/rbenv-use
git clone https://github.com/tpope/rbenv-communal-gems.git      $RBENV_PLUGINS/rbenv-communal-gems
git clone https://github.com/nicknovitski/rbenv-gem-update      $RBENV_PLUGINS/rbenv-gem-update

/usr/local/bin/brew install openssl libyaml libffi

rbenv install 2.3.1
rbenv alias --auto
rbenv use 2.3.1 --global
rbenv communize --all