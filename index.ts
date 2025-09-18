#!/usr/bin/env node

import { spawn } from "node:child_process";
import { existsSync, mkdirSync, createWriteStream, unlinkSync, rmSync, renameSync } from "node:fs";
import * as https from "node:https";
import * as path from "node:path";

/**
 * Main function
 */
async function main() {
  setup();
};

/**
 * SDDのセットアップをする
 */
async function setup() {
  const rootDir = await getGitRoot();
  const specDir = `${rootDir}/.spec`;

  // .specディレクトリの存在チェック
  if(existsSync(specDir)) {
    console.log(".spec directory already exists.");
    return;
  }

  try {
    // .specディレクトリの作成
    mkdirSync(`${specDir}`, { recursive: true });

    // テンプレートのダウンロード
    await downloadTemplate(specDir);
  } catch (error) {
    console.error("Error creating .spec directory:", error);
  }
}

/**
 * ファイルをダウンロードする
 *
 * @param url ダウンロード元のURL
 * @param destPath 保存先パス
 */
function downloadFile(url: string, destPath: string): Promise<void> {
  return new Promise((resolve, reject) => {
    const file = createWriteStream(destPath);

    https.get(url, (response) => {
      // リダイレクトの処理
      if (response.statusCode === 302 || response.statusCode === 301) {
        const redirectUrl = response.headers.location;
        if (redirectUrl) {
          file.close();
          downloadFile(redirectUrl, destPath).then(resolve).catch(reject);
          return;
        }
      }

      if (response.statusCode !== 200) {
        reject(new Error(`Failed to download: ${response.statusCode}`));
        return;
      }

      response.pipe(file);

      file.on('finish', () => {
        file.close();
        resolve();
      });
    }).on('error', (err) => {
      unlinkSync(destPath);
      reject(err);
    });
  });
}

/**
 * ZIPファイルを解凍する
 *
 * @param zipPath ZIPファイルのパス
 * @param destDir 解凍先ディレクトリ
 */
function unzipFile(zipPath: string, destDir: string): Promise<void> {
  return new Promise((resolve, reject) => {
    const unzip = spawn('unzip', ['-q', zipPath, '-d', destDir]);

    unzip.on('close', (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`unzip process exited with code ${code}`));
      }
    });

    unzip.on('error', (err) => {
      reject(err);
    });
  });
}

/**
 * GitHubからテンプレートをダウンロードして展開する
 *
 * @param specDir .specディレクトリのパス
 */
async function downloadTemplate(specDir: string) {
  const repoUrl = 'https://github.com/soukadao/sdd-template/archive/refs/heads/main.zip';
  const tempZipPath = path.join(specDir, 'temp_template.zip');

  try {
    console.log('Downloading template from GitHub...');
    await downloadFile(repoUrl, tempZipPath);

    console.log('Extracting template...');
    await unzipFile(tempZipPath, specDir);

    // 解凍されたディレクトリから必要なディレクトリを移動
    const extractedDir = path.join(specDir, 'sdd-template-main');
    const targetDirs = ['commands', 'template', 'work', 'scripts'];

    for (const dir of targetDirs) {
      const sourcePath = path.join(extractedDir, 'package', dir);
      const destPath = path.join(specDir, dir);

      if (existsSync(sourcePath)) {
        if (existsSync(destPath)) {
          rmSync(destPath, { recursive: true, force: true });
        }
        renameSync(sourcePath, destPath);
        console.log(`✓ ${dir} directory added to .spec/`);
      } else {
        console.log(`⚠ ${dir} directory not found in template`);
      }
    }

    // 一時ファイルとディレクトリの削除
    rmSync(extractedDir, { recursive: true, force: true });
    unlinkSync(tempZipPath);

    console.log('\n✅ Template download completed successfully!');

  } catch (error) {
    console.error('Error downloading template:', error);

    // クリーンアップ
    if (existsSync(tempZipPath)) {
      unlinkSync(tempZipPath);
    }

    throw error;
  }
}

/**
 * Gitのルートディレクトリを取得する
 *
 * @returns {Promise<string>}
 */
async function getGitRoot(): Promise<string> {
  return new Promise((resolve, reject) => {
    const proc = spawn("git", ["rev-parse", "--show-toplevel"]);
    let output = '';
    let errorOutput = '';

    proc.stdout.on('data', (data) => {
      output += data.toString();
    });

    proc.stderr.on('data', (data) => {
      errorOutput += data.toString();
    });

    proc.on('close', (code) => {
      if (code === 0) {
        resolve(output.trim());
      } else {
        reject(new Error(`Not a git repository: ${errorOutput}`));
      }
    });

    proc.on('error', (err) => {
      reject(err);
    });
  });
}

main().catch((error) => {
  console.error("Application error:", error);
  process.exit(1);
});