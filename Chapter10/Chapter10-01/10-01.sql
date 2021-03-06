/*演習10-1 一意集合と多重集合の一般化
「一意集合と多重集合」(p.180)では、materialという一列のみをキーにして
集合内の重複値の有無を調べました。これを一般化して、複数のキーについて
重複を調べてみましょう。
サンプルデータとして、次のように「原産国」列を追加したテーブルを使います。

資材テーブル(material_table)
 center_name | receive_date | material_name |  orgland_name
-------------+--------------+---------------+----------------
 東京        | 2007-04-01   | 銅            | チリ
 東京        | 2007-04-12   | 亜鉛          | タイ
 東京        | 2007-05-17   | アルミニウム  | ブラジル
 東京        | 2007-05-20   | 亜鉛          | タイ
 大阪        | 2007-04-20   | 銅            | オーストラリア
 大阪        | 2007-04-22   | ニッケル      | 南アフリカ
 大阪        | 2007-04-29   | 鉛            | インド
 名古屋      | 2007-03-15   | チタン        | ボリビア
 名古屋      | 2007-04-01   | 炭素鋼        | チリ
 名古屋      | 2007-04-24   | 炭素鋼        | アルゼンチン
 名古屋      | 2007-05-02   | マグネシウム  | チリ
 名古屋      | 2007-05-10   | チタン        | タイ
 福岡        | 2007-05-10   | 亜鉛          | アメリカ
 福岡        | 2007-05-28   | 錫            | ロシア

では問題です。(資材、原産国)の2列で見たときにダブっている拠点を選択して
ください。答えは、(亜鉛、タイ)がダブる「東京」拠点だけになります。
名古屋は資材だけみれば「炭素鋼」が重複していますが、原産国が
チリとアルゼンチンなので、対象外です。*/

--取得値
SELECT
	--資源・原産国でダブりのある拠点
	center_name
--参照範囲
FROM
	--資材テーブル
	material_table
--部分集合化を行うキー値
GROUP BY
	--拠点名
	center_name
--取得する部分集合の条件
HAVING
	--資源・原産国でのダブりがあるかとうかを調べるため、両列名を結合して一つの値であるかのように扱う
	COUNT(material_name || orgland_name) <> COUNT(DISTINCT material_name || orgland_name)
;

/*出力
 center_name
-------------
 東京
*/
