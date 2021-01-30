#cloud-config

runcmd:  

#gitをインストール
 - sudo yum -y install git

#dockerをインストール
 - sudo yum -y install docker

#docker-composeをインストール
 - sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

#docker-composeのシンボルを作成
 - sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

#docker-composeに実行権限を追加
 - sudo chmod +x /usr/local/bin/docker-compose

#railsアプをダウロード
 - sudo git clone https://github.com/zsbinging84/circleci_test.git /home/ec2-user/circleci_test/

#マスタキーファイル作成
 - sudo touch /home/ec2-user/circleci_test/config/master.key

#マスタキーファイル作成
 - sudo echo "eeee29e76f9048bb4b78bb86417df7f4" > /home/ec2-user/circleci_test/config/master.key

#dockerを起動
 - sudo service docker start

#dockerを起動
 - sudo cd /home/ec2-user/circleci_test/

#DBの作成とテーブルの適用
 - sudo docker-compose -f /home/ec2-user/circleci_test/docker-compose.prod.yml run app rails db:create

#DBの作成とテーブルの適用
 - sudo docker-compose -f /home/ec2-user/circleci_test/docker-compose.prod.yml run app rails db:migrate

#DBの作成とテーブルの適用
 - sudo docker-compose -f /home/ec2-user/circleci_test/docker-compose.prod.yml run app rails webpacker:install

#DBの作成とテーブルの適用
 - sudo docker-compose -f /home/ec2-user/circleci_test/docker-compose.prod.yml run app rails webpacker:compile

#railsアプリのコンテナ起動
 - sudo docker-compose -f /home/ec2-user/circleci_test/docker-compose.prod.yml up -d

