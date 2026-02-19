# プロジェクト移植・統合計画

## 背景
- **newmap**: 既存のビジネスインパクトマップ（継続開発）
- **tree-management**: 新規の樹木管理システム（PoC版完成）

両プロジェクトの共通機能を整理し、保守性・再利用性を高める。

---

## Phase 1: 新アプリ PoC（完了✅）

### 目的
樹木管理システムの早期フィージビリティ検証

### 実施内容
- [x] newmap/index.htmlをベースにコピー
- [x] タイトル・UI要素を樹木管理用に変更
- [x] ポイントタイプを樹木用に変更（tree, waypoint）
- [x] ポイント属性を簡素化（樹種、登録日のみ）
- [x] フォーム項目の調整
- [x] README作成

### 次のステップ
- [ ] 動作確認とバグ修正
- [ ] ユーザーフィードバック収集
- [ ] 必要に応じて微調整

---

## Phase 2: コア機能の抽出・整備（2-4週間）

### 目的
両プロジェクトの共通部分をモジュール化し、再利用可能にする

### 実施計画

#### 2.1 共通機能の特定
以下の機能を共通コアとして抽出：

**地図表示・操作**
- Leaflet初期化
- ズーム・パン機能
- ズームスライダー

**ポイント管理**
- マーカー追加・編集・削除
- カスタムアイコン生成
- ポップアップ表示
- マーカードラッグ

**エリア管理**
- 円形・多角形描画
- エリア編集・削除
- Range判定（Point-in-Polygon）

**住所検索**
- ジオコーディングAPI連携
- 住所→座標変換

**データ管理**
- localStorageへの保存
- JSON/CSVインポート・エクスポート
- データ構造の正規化

**UI共通部分**
- フローティングパネル
- リサイズ・ドラッグ機能
- セクション折りたたみ

#### 2.2 コードの整理方法

**方法A: ファイル分割（推奨）**
```
common/
  ├── leaflet-core.js      # 地図初期化・基本操作
  ├── point-manager.js     # ポイント管理
  ├── area-manager.js      # エリア管理
  ├── geocoding.js         # 住所検索
  ├── data-manager.js      # データ保存/読込
  └── ui-components.js     # 共通UI部品

newmap/
  ├── index.html
  ├── app-config.js        # アプリ固有設定
  └── business-logic.js    # ビジネス固有機能

tree-management/
  ├── index.html
  ├── app-config.js        # アプリ固有設定
  └── tree-logic.js        # 樹木管理固有機能
```

**方法B: configベース**
```javascript
// アプリ設定で差異を吸収
const appConfig = {
  appName: "樹木管理システム",
  pointTypes: [
    { id: 'tree', icon: '🌳', label: '樹木' }
  ],
  pointFields: [
    { id: 'tree_species', label: '樹種', type: 'text' },
    { id: 'registered_date', label: '登録日', type: 'date' }
  ],
  enabledFeatures: {
    hazardLayers: false,
    companyLayer: false,
    polygonAggregation: true
  }
};
```

#### 2.3 作業手順
1. **共通機能のコメント付け**: 両ファイルで共通部分にマーク
2. **共通関数の抽出**: 独立した.jsファイルに移動
3. **設定ファイルの作成**: アプリ固有ロジックを分離
4. **リファクタリング**: DRY原則に基づき重複を削減
5. **テスト**: 両アプリで動作確認

---

## Phase 3: アーキテクチャ刷新（長期）

### 目的
本格的なマルチプロジェクト対応基盤の構築

### 実施計画

#### 3.1 共通コアライブラリ化
```
map-platform/
  ├── core/
  │   ├── MapManager.js
  │   ├── PointManager.js
  │   ├── AreaManager.js
  │   └── DataManager.js
  ├── plugins/
  │   ├── geocoding-plugin.js
  │   ├── hazard-layer-plugin.js
  │   └── aggregation-plugin.js
  └── config/
      └── default-config.js
```

#### 3.2 プラグインシステム
各アプリは必要な機能をプラグインとして読み込む：

```javascript
const app = new MapPlatform({
  config: treeManagementConfig,
  plugins: [
    'geocoding',
    'polygon-aggregation'
    // 'hazard-layer' は不要なので読み込まない
  ]
});
```

#### 3.3 TypeScript化（オプション）
- 型安全性の向上
- IDE補完の強化
- 大規模開発への対応

#### 3.4 ビルドシステム導入
- Webpack / Vite
- モジュールバンドリング
- 開発サーバー
- Hot Reload

---

## 各フェーズの判断基準

### Phase 1 → Phase 2 移行タイミング
- ✅ PoCが実用に耐えるレベルに達した
- ✅ 3つ目以降のアプリ開発の予定がある
- ✅ コードの保守コストが高まっている

### Phase 2 → Phase 3 移行タイミング
- ✅ 5つ以上のアプリを運用している
- ✅ チーム開発が必要になった
- ✅ 外部公開・配布を考えている

---

## リスクと対策

### リスク
1. **Phase 2での過度な抽象化**: 逆に保守性が下がる
2. **既存アプリへの影響**: リファクタリングでバグ混入
3. **学習コスト**: 新しいアーキテクチャへの習熟

### 対策
1. 必要最小限の抽象化から始める
2. 十分なテストとバックアップ
3. 段階的な移行とドキュメント整備

---

## 次のアクション

### すぐやること（Phase 1完了）
- [ ] tree-managementの動作確認
- [ ] 簡単な樹木データを登録してみる
- [ ] バグがあれば修正

### Phase 2準備
- [ ] newmapとtree-managementの共通部分をリストアップ
- [ ] どの機能を共通化するか優先順位をつける
- [ ] ファイル分割 vs config方式のどちらで進めるか決定

### Phase 3準備（余裕があれば）
- [ ] TypeScript の学習
- [ ] モダンなフロントエンド開発手法の調査
