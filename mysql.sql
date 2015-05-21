----補足
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


grant all on blog_app.* to dbuser@localhost identified by '設定したいパスワード';


◆確認用
exit;
mysql -u dbuser -p blog_app


◆動作確認　テーブルの作成
create table users {
id int,
name varchar(255),
email varchar(255),
password char(32)
};

◆テーブルを確認
show tables;

◆テーブルを削除
drop table users;
show tables;


◆テーブルを作成
create table users {
id int not null auto_increment primary key,
name varchar(255),
email varchar(255) unique,
password char(32),
score double,
sex enum('male', 'female') default 'male',
memo text,
created datetime,
key score (score)
};

◆データを挿入
insert into users (name,email,password,score,memo,created) values ('taiti','taiti@stone-rise.com','123456','5','test','2015-04-20 11:00:00');

◆データ確認
select * from users;

◆ここまでのテストでのtableは一旦削除
drop database users;

◆新しくtableを作成
create table users {
id int not null primary key auto_increment,
name varchar(255),
email varchar(255),
team enum('blue','red','yellow'),
score double,
created datetime
};

◆テスト用のデータ作成
insert into users (name,email,team,score,created) values (
('taguchi','taguchi@dotinstall.com','blue',5.5,'2012-05-11 11:00:00'),
('fkoji','fkoji@dotinstall.com','yellow',8.2,'2012-06-21 12:00:00'),
('dotinstall','dotinstall@dotinstall.com','red',2.3,'2012-06-21 13:00:00'),
('sasaki','sasaki@dotinstall.jp','blue',4.5,'2012-06-25 14:00:00'),
('kimura','','yellow',7.4,'2012-06-28 15:00:00'),
('tanaka','tanaka@dotinstall.jp','blue',4.2,'2012-06-29 16:00:00')
);

◆確認用
select * from users;

select * from users where score != 5.5;

select * from users where score <> 5.5;

select * from users where team <> 'red';

select * from users where created <> '2011-06-01 11:00:00';

select * from users where email like '%@dotinstall.com';

select * from users where email like '%@dotinstall.__';

select * from users where score between 5.0 and 8.0;
select * from users where team in ('red', 'yellow');
select * from users where score >= 4.0 and team = 'blue';
select * from users where score >= 4.0 or team = 'blue';
select * from users order by score;
select * from users order by score desc;
select * from users order by name desc;
select * from users limit 3;
select * from users limit 2, 2;
select * from users order by score desc limit 3;


◆データの集計
select count(*) from users;
select distinct team from users;
select max(score) from users;
select avg(score) from users;
select sum(score) from users;
select sum(score) from users group by team;
select rand();
select * from users order by rand() limit 1;

◆文字列や日付から検索
select email, length(email) from users;
select concat(name, '(', team, ')') from users;
select concat(name, '(', team, ')') as label from users;
select name, substring(team, 1, 1) from users;
select now();
select name, month(created) from users;
select name, datediff(now(), created) from users;

◆データの更新と修正
update users set email = 'kimura@dotinstall.jp' where id = 5;
select * from users;
delete from users where score <= 3.0;
select * from users;

◆テーブルの構造を変更してみる
desc users;
alter table users add full_name varchar(255) after name;
desc users;
alter table users change full_name full_name varchar(100);
desc users;
alter table users drop full_name;
desc users;
alter table users add index email (email);
desc users;
alter table users drop index email;
desc users;
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