----補足使えるデータ型
* 数値
- int
- double
 
* 文字列
- char
- varchar
- text
 
* 日付
- date
- datetime
 
* それ以外
- enum

◆ユーザーの確認
select Host, User, Password from mysql.user;

◆ユーザーの削除
DROP USER 'dbuser'@'localhost';

◆rootユーザーの作成、初期化
set password for root@localhost=password('設定したいパスワード');

◆確認テスト　rootでログインする。
exit
mysql -u root -p

◆DBを作成する。
create database blog_app;
show databases;

◆テストようなので一度削除する
drop database blog_app;

◆DBを確認する。
use blog_app;

◆作業用ユーザーを作成
-rootユーザーでログインする。
mysql -u root -p

◆rootユーザーからDBを作成する。
create database blog_app;


grant all on blog_app.* to dbuser@localhost identified by '123456';


◆確認用
exit;
mysql -u dbuser -p blog_app


◆動作確認　テーブルの作成
create table users (
id int,
name varchar(255),
email varchar(255),
password char(32)
);

◆テーブルを確認
show tables;

◆テーブルを削除
drop table users;
show tables;


◆テーブルを作成
create table users (
id int not null auto_increment primary key,
name varchar(255),
email varchar(255) unique,
password char(32),
score double,
sex enum('male', 'female') default 'male',
memo text,
created datetime,
key score (score)
);

◆データを挿入
insert into users (name,email,password,score,memo,created) values ('taiti','taiti@stone-rise.com','123456','5','test','2015-04-20 11:00:00');

◆データ確認
select * from users;

◆ここまでのテストでのtableは一旦削除
drop table users;

◆新しくtableを作成
create table users (
id int not null primary key auto_increment,
name varchar(255),
email varchar(255),
team enum('blue','red','yellow'),
score double,
created datetime
);

◆テスト用のデータ作成
insert into users (name,email,team,score,created) values 
('taguchi','taguchi@dotinstall.com','blue',5.5,'2012-05-11 11:00:00'),
('fkoji','fkoji@dotinstall.com','yellow',8.2,'2012-06-21 12:00:00'),
('dotinstall','dotinstall@dotinstall.com','red',2.3,'2012-06-21 13:00:00'),
('sasaki','sasaki@dotinstall.jp','blue',4.5,'2012-06-25 14:00:00'),
('kimura','','yellow',7.4,'2012-06-28 15:00:00'),
('tanaka','tanaka@dotinstall.jp','blue',4.2,'2012-06-29 16:00:00')
;

◆確認用
◆◆すべて表示させる
select * from users;

◆◆!=の後以外を表示させる
select * from users where score != 5.5;

◆◆<>の後以外を表示させる
select * from users where score <> 5.5;

◆◆あいまい検索
select * from users where email like '%@dotinstall.com';

◆◆あいまい検索 _これで文字数を指定している　
select * from users where email like '%@dotinstall.__';

◆◆範囲の指定　between
select * from users where score between 5.0 and 8.0;

◆◆範囲の指定　in（予め設定した範囲内にあるか）
select * from users where team in ('red', 'yellow');

◆◆応用
select * from users where score >= 4.0 and team = 'blue';
select * from users where score >= 4.0 or team = 'blue';

◆◆並び替え スコア順に並び替える
select * from users order by score;

◆◆並び替え スコア順に並び替える　逆に表示させる
select * from users order by score desc;
select * from users order by name desc;

◆◆並び替え　件数の指定
select * from users limit 3;
select * from users limit 2, 2;

◆◆並び替え　スコアの大きい順　上から3つ
select * from users order by score desc limit 3;


◆データの集計
-データがいくつあるか確認
select count(*) from users;

-カラムにあるデータの確認
select distinct team from users;

-カラムのデータの最大値の確認
select max(score) from users;

-カラムのデータの平均値を求める
select avg(score) from users;

-カラムのデータの合計値を求める
select sum(score) from users;

-グループごとの合計値を確認する
select sum(score) from users group by team;

-ランダムでデータを取得できる
select rand();
select * from users order by rand() limit 1;

◆文字列や日付から検索
-文字列の数を検索する
select email, length(email) from users;

-ラベルをつけて検索する。
select concat(name, '(', team, ')') as label from users;

-文字列の検索
select name, substring(team, 1, 1) from users;

-現在時刻の取得
select now();

-作成月の取得
select name, month(created) from users;

-日付の差分を取る
select name, datediff(now(), created) from users;

◆データの更新と修正
-データの更新
update users set email = 'kimura@dotinstall.jp' where id = 5;
select * from users;

-削除（scoreのなになに以下）
delete from users where score <= 3.0;
select * from users;

◆テーブルの構造を変更してみる
desc users;

-カラムを追加する。
alter table users add full_name varchar(255) after name;
desc users;

-カラムの構造を変更する。（varcharを変更するなど）
alter table users change full_name full_name varchar(100);
desc users;

-カラムを削除する。
alter table users drop full_name;
desc users;

-キーをつける。
alter table users add index email (email);
desc users;

-キーを削除する。
alter table users drop index email;
desc users;

-table名を変更する。
alter table users rename blog_users;
show tables;


◆joinを使った結合でselect

-データ準備
create table users (
  id int not null primary key auto_increment,
  name varchar(255),
  email varchar(255),
  team enum('blue','red','yellow'),
  score double,
  created datetime
);
 
insert into users (name,email,team,score,created) values 
('taguchi','taguchi@dotinstall.com','blue',5.5,'2012-05-11 11:00:00'),
('fkoji','fkoji@dotinstall.com','yellow',8.2,'2012-06-21 12:00:00'),
('dotinstall','dotinstall@dotinstall.com','red',2.3,'2012-06-21 13:00:00');
 
create table posts (
  id int not null primary key auto_increment,
  user_id int not null,
  title varchar(255),
  body text,
  created datetime
);
 
insert into posts (user_id,title,body,created) values 
(1, 'title-1 by taguchi', 'body-1','2012-05-11 14:00:00'),
(1, 'title-2 by taguchi', 'body-2','2012-05-11 12:00:00'),
(2, 'title-3 by fkoji', 'body-3','2012-05-11 13:00:00'),
(3, 'title-4 by dotinstall', 'body-4','2012-05-11 10:00:00'),
(3, 'title-5 by dotinstall', 'body-5','2012-05-11 09:00:00');

◆データ確認
select * from users;
select * from posts;
select users.name, posts.title from users, posts where users.id = posts.user_id;
select users.name, posts.title from users, posts where users.id = posts.user_id order by posts.created desc;

◆最後に外部ファイルをインポートするときは「sqlファイルを使用すること。」