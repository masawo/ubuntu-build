# Packer + Ansible で、ubuntu linux のサーバを設定する
Amazon EC2で使うイメージ(AMI)を構築する前に、ローカルで試したときの記録

## 構築する形式
- virtualbox(ローカル向け)

## 使用ツール
Packer でOSインストール〜初期設定をしたあと、Ansible で細かい設定を行う。

- [Packer by HashiCorp](https://www.packer.io/)
- [Ansible Documentation](http://docs.ansible.com/)
- [Vagrant](https://www.vagrantup.com/)
- [ViatualBox](https://www.virtualbox.org/)

## インストール

### Packer, Ansibleのインストール

```
% brew install packer
% brew install ansible
```
### Vagrant のインストール
[Vagrant](https://www.vagrantup.com/) からダウンロード  
※homebrew でも良いのかもしれない

### VirtualBoxのインストール
[ViatualBox](https://www.virtualbox.org/)


### rubyのインストールで使うgalaxyを入れる
https://galaxy.ansible.com/zzet/rbenv/

```
% ansible-galaxy install zzet.rbenv
```

### ビルド
ベースとなるvagrant用イメージ(box)をローカルでビルドする
- OSインストール
- 共通で必要なsoftwareを導入
  - 必要なapt
  - nginx
  - rbenv

```
% packer build ubuntu-base.json
```

↑でできたboxをマウントする
```
% vagrant box add ubuntu boxes/ubuntu-16.04-amd64-virtualbox-ubuntu-base.box
% vagrant up
% vagrant halt
```

すると以下にovfファイルが生成されるので、これを次の packer build につかう。  
`~/.vagrant.d/boxes/ubuntu/0/virtualbox/box.ovf`

```
% packer build ubuntu-app.json
```

できあがったら、vagrant up して動作確認
```
% vagrant box add ubuntu boxes/ubuntu-16.04-amd64-virtualbox-ubuntu-app.box
% vagrant up
% vagrant ssh
```

消すとき
```
% vagrant destroy
% vagrant box remove ubuntu
```

## ansibleでなにか追加するとき
packer build をおこなうと、終わるまで結構時間がかかる(baseのイメージは数十分)。  
Vagrantfile の以下をコメントアウトすれば vagrant provision で任意のymlを動かすことができるので、追加する場合はそこでテストができる。 

```
#  config.vm.provision "ansible" do |ansible|
#    ansible.verbose = "v"
#    ansible.playbook = "ansible/tmp.yml"
#  end
```

## 参考情報
- [PackerでAmazon LinuxのAMI\(Amazon Machine Image\)を作成する ｜ Developers\.IO](http://dev.classmethod.jp/cloud/aws/create_amazon-ami_by_packer/)
- [1コマンドで本番サーバと開発サーバ \(のVMイメージ\)を作る話 \- VASILY DEVELOPERS BLOG](http://tech.vasily.jp/entry/create-prod-and-dev-vm-image-atst-by-packer)
- [kaorimatz/packer\-templates: Packer templates for Vagrant base boxes](https://github.com/kaorimatz/packer-templates)
  - VirtualBoxでのビルドはここを参考にした
