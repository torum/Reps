using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Windows;
using System.Windows.Media;
using System.Windows.Controls;
using System.Xml;
using System.Xml.Linq;
using System.Windows.Data;
using System.Windows.Input;
using System.IO;
using System.ComponentModel;
using Reps.Common;
using System.Collections.ObjectModel;
using System.Linq;
using System.Media;
using System.Windows.Threading;

namespace Reps.ViewModels
{

    #region == テーマ用のクラス ==

    /// <summary>
    /// テーマ用のクラス
    /// </summary>
    public class Theme
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Label { get; set; }
        public string IconData { get; set; }
    }

    #endregion

    public class MainViewModel : ViewModelBase
    {

        #region == 基本 ==

        // Application version
        private string _appVer = "0.0.0.1";

        // Application name
        private string _appName = "Reps";

        // Application config file folder
        private string _appDeveloper = "torum";

        // Application Window Title
        public string AppTitle
        {
            get
            {
                return _appName + " " + _appVer;
            }
        }

        #endregion

        #region == 表示切替 ==

        // 設定画面表示フラグ
        private bool _showSettings = false;
        public bool ShowSettings
        {
            get
            {
                return _showSettings;
            }
            set
            {
                if (_showSettings == value) return;

                _showSettings = value;
                this.NotifyPropertyChanged("ShowSettings");

                if (_showSettings)
                    ShowMainContents = false;
                else
                    ShowMainContents = true;
            }
        }

        // 設定画面表示中にメインの内容を隠すフラグ
        private bool _showMainContents = true;
        public bool ShowMainContents
        {
            get
            {
                return _showMainContents;
            }
            set
            {
                if (_showMainContents == value) return;

                _showMainContents = value;
                this.NotifyPropertyChanged("ShowMainContents");
            }
        }

        #endregion

        #region == テーマ関係 ==

        // テーマ一覧
        private ObservableCollection<Theme> _themes;
        public ObservableCollection<Theme> Themes
        {
            get { return _themes; }
            set { _themes = value; }
        }

        // テーマ切替
        private Theme _currentTheme;
        public Theme CurrentTheme
        {
            get
            {
                return _currentTheme;
            }
            set
            {
                if (_currentTheme == value) return;

                _currentTheme = value;
                this.NotifyPropertyChanged("CurrentTheme");

                (Application.Current as App).ChangeTheme(_currentTheme.Name);

            }
        }

        // 画面透過率
        private double _windowOpacity = 0.3;
        public double WindowOpacity
        {
            get
            {
                return _windowOpacity;
            }
            set
            {
                if (_windowOpacity == value) return;

                _windowOpacity = value;
                this.NotifyPropertyChanged("WindowOpacity");
            }
        }

        #endregion

        /// <summary>
        /// メインのビューモデル
        /// </summary>
        public MainViewModel()
        {
            // コマンドのイニシャライズ
            ShowSettingsCommand = new RelayCommand(ShowSettingsCommand_Execute, ShowSettingsCommand_CanExecute);
            SettingsCancelCommand = new RelayCommand(SettingsCancelCommand_Execute, SettingsCancelCommand_CanExecute);
            SettingsOKCommand = new RelayCommand(SettingsOKCommand_Execute, SettingsOKCommand_CanExecute);

            #region == テーマのイニシャライズ ==

            // テーマの選択コンボボックスのイニシャライズ
            _themes = new ObservableCollection<Theme>()
            {
                new Theme() { Id = 1, Name = "DefaultTheme", Label = "Dark", IconData="M17.75,4.09L15.22,6.03L16.13,9.09L13.5,7.28L10.87,9.09L11.78,6.03L9.25,4.09L12.44,4L13.5,1L14.56,4L17.75,4.09M21.25,11L19.61,12.25L20.2,14.23L18.5,13.06L16.8,14.23L17.39,12.25L15.75,11L17.81,10.95L18.5,9L19.19,10.95L21.25,11M18.97,15.95C19.8,15.87 20.69,17.05 20.16,17.8C19.84,18.25 19.5,18.67 19.08,19.07C15.17,23 8.84,23 4.94,19.07C1.03,15.17 1.03,8.83 4.94,4.93C5.34,4.53 5.76,4.17 6.21,3.85C6.96,3.32 8.14,4.21 8.06,5.04C7.79,7.9 8.75,10.87 10.95,13.06C13.14,15.26 16.1,16.22 18.97,15.95M17.33,17.97C14.5,17.81 11.7,16.64 9.53,14.5C7.36,12.31 6.2,9.5 6.04,6.68C3.23,9.82 3.34,14.64 6.35,17.66C9.37,20.67 14.19,20.78 17.33,17.97Z"},
                new Theme() { Id = 2, Name = "LightTheme", Label = "Light", IconData="M12,7A5,5 0 0,1 17,12A5,5 0 0,1 12,17A5,5 0 0,1 7,12A5,5 0 0,1 12,7M12,9A3,3 0 0,0 9,12A3,3 0 0,0 12,15A3,3 0 0,0 15,12A3,3 0 0,0 12,9M12,2L14.39,5.42C13.65,5.15 12.84,5 12,5C11.16,5 10.35,5.15 9.61,5.42L12,2M3.34,7L7.5,6.65C6.9,7.16 6.36,7.78 5.94,8.5C5.5,9.24 5.25,10 5.11,10.79L3.34,7M3.36,17L5.12,13.23C5.26,14 5.53,14.78 5.95,15.5C6.37,16.24 6.91,16.86 7.5,17.37L3.36,17M20.65,7L18.88,10.79C18.74,10 18.47,9.23 18.05,8.5C17.63,7.78 17.1,7.15 16.5,6.64L20.65,7M20.64,17L16.5,17.36C17.09,16.85 17.62,16.22 18.04,15.5C18.46,14.77 18.73,14 18.87,13.21L20.64,17M12,22L9.59,18.56C10.33,18.83 11.14,19 12,19C12.82,19 13.63,18.83 14.37,18.56L12,22Z"}
            };
            // デフォルトにセット
            _currentTheme = _themes[0];

            #endregion

        }

        #region == イベント・タイマー系 ==

        // 起動時の処理
        public void OnWindowLoaded(object sender, RoutedEventArgs e)
        {
            // データ保存フォルダの取得
            var AppDataFolder = System.Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
            AppDataFolder = AppDataFolder + System.IO.Path.DirectorySeparatorChar + _appDeveloper + System.IO.Path.DirectorySeparatorChar + _appName;
            // 存在していなかったら作成
            System.IO.Directory.CreateDirectory(AppDataFolder);

            #region == アプリ設定のロード  ==

            // 設定ファイルのパス
            var AppConfigFilePath = AppDataFolder + System.IO.Path.DirectorySeparatorChar + _appName + ".config";

            // アプリ設定情報の読み込み
            if (File.Exists(AppConfigFilePath))
            {
                XDocument xdoc = XDocument.Load(AppConfigFilePath);

                #region == ウィンドウ関連 ==

                if (sender is Window)
                {
                    // Main Window element
                    var mainWindow = xdoc.Root.Element("MainWindow");
                    if (mainWindow != null)
                    {
                        var hoge = mainWindow.Attribute("top");
                        if (hoge != null)
                        {
                            (sender as Window).Top = double.Parse(hoge.Value);
                        }

                        hoge = mainWindow.Attribute("left");
                        if (hoge != null)
                        {
                            (sender as Window).Left = double.Parse(hoge.Value);
                        }

                        hoge = mainWindow.Attribute("height");
                        if (hoge != null)
                        {
                            (sender as Window).Height = double.Parse(hoge.Value);
                        }

                        hoge = mainWindow.Attribute("width");
                        if (hoge != null)
                        {
                            (sender as Window).Width = double.Parse(hoge.Value);
                        }

                        hoge = mainWindow.Attribute("state");
                        if (hoge != null)
                        {
                            if (hoge.Value == "Maximized")
                            {
                                (sender as Window).WindowState = WindowState.Maximized;
                            }
                            else if (hoge.Value == "Normal")
                            {
                                (sender as Window).WindowState = WindowState.Normal;
                            }
                            else if (hoge.Value == "Minimized")
                            {
                                (sender as Window).WindowState = WindowState.Normal;
                            }
                        }

                        hoge = mainWindow.Attribute("opacity");
                        if (hoge != null)
                        {
                            WindowOpacity = double.Parse(hoge.Value);
                        }

                        hoge = mainWindow.Attribute("theme");
                        if (hoge != null)
                        {
                            // テーマをセット
                            SetCurrentTheme(hoge.Value);
                        }

                    }

                }

                #endregion

            }
            else
            {
                // デフォ
            }

            #endregion


        }

        // 終了時の処理
        public void OnWindowClosing(object sender, CancelEventArgs e)
        {
            // データ保存フォルダの取得
            var AppDataFolder = System.Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
            AppDataFolder = AppDataFolder + System.IO.Path.DirectorySeparatorChar + _appDeveloper + System.IO.Path.DirectorySeparatorChar + _appName;
            // 存在していなかったら作成
            System.IO.Directory.CreateDirectory(AppDataFolder);

            #region == アプリ設定の保存 ==

            // 設定ファイルのパス
            var AppConfigFilePath = AppDataFolder + System.IO.Path.DirectorySeparatorChar + _appName + ".config";

            // 設定ファイル用のXMLオブジェクト
            XmlDocument doc = new XmlDocument();
            XmlDeclaration xmlDeclaration = doc.CreateXmlDeclaration("1.0", "UTF-8", null);
            doc.InsertBefore(xmlDeclaration, doc.DocumentElement);

            // Root Document Element
            XmlElement root = doc.CreateElement(string.Empty, "App", string.Empty);
            doc.AppendChild(root);

            XmlAttribute attrs = doc.CreateAttribute("Version");
            attrs.Value = _appVer;
            root.SetAttributeNode(attrs);

            #region == ウィンドウ関連 ==

            if (sender is Window)
            {
                // Main Window element
                XmlElement mainWindow = doc.CreateElement(string.Empty, "MainWindow", string.Empty);

                // Main Window attributes
                attrs = doc.CreateAttribute("height");
                if ((sender as Window).WindowState == WindowState.Maximized)
                {
                    attrs.Value = (sender as Window).RestoreBounds.Height.ToString();
                }
                else
                {
                    attrs.Value = (sender as Window).Height.ToString();
                }
                mainWindow.SetAttributeNode(attrs);

                attrs = doc.CreateAttribute("width");
                if ((sender as Window).WindowState == WindowState.Maximized)
                {
                    attrs.Value = (sender as Window).RestoreBounds.Width.ToString();
                }
                else
                {
                    attrs.Value = (sender as Window).Width.ToString();

                }
                mainWindow.SetAttributeNode(attrs);

                attrs = doc.CreateAttribute("top");
                if ((sender as Window).WindowState == WindowState.Maximized)
                {
                    attrs.Value = (sender as Window).RestoreBounds.Top.ToString();
                }
                else
                {
                    attrs.Value = (sender as Window).Top.ToString();
                }
                mainWindow.SetAttributeNode(attrs);

                attrs = doc.CreateAttribute("left");
                if ((sender as Window).WindowState == WindowState.Maximized)
                {
                    attrs.Value = (sender as Window).RestoreBounds.Left.ToString();
                }
                else
                {
                    attrs.Value = (sender as Window).Left.ToString();
                }
                mainWindow.SetAttributeNode(attrs);

                attrs = doc.CreateAttribute("state");
                if ((sender as Window).WindowState == WindowState.Maximized)
                {
                    attrs.Value = "Maximized";
                }
                else if ((sender as Window).WindowState == WindowState.Normal)
                {
                    attrs.Value = "Normal";

                }
                else if ((sender as Window).WindowState == WindowState.Minimized)
                {
                    attrs.Value = "Minimized";
                }
                mainWindow.SetAttributeNode(attrs);

                attrs = doc.CreateAttribute("opacity");
                attrs.Value = WindowOpacity.ToString();
                mainWindow.SetAttributeNode(attrs);

                attrs = doc.CreateAttribute("theme");
                attrs.Value = CurrentTheme.Name.ToString();
                mainWindow.SetAttributeNode(attrs);

                // set Main Window element to root.
                root.AppendChild(mainWindow);

            }

            #endregion

            // 設定ファイルの保存
            doc.Save(AppConfigFilePath);

            #endregion

        }

        #endregion

        #region == メソッド ==

        // テーマをセットするメソッド
        private void SetCurrentTheme(string themeName)
        {
            Theme test = _themes.FirstOrDefault(x => x.Name == themeName);
            if (test != null)
            {
                CurrentTheme = test;
            }
        }

        #endregion

        #region == コマンド ==

        // 設定画面表示
        public ICommand ShowSettingsCommand { get; }
        public bool ShowSettingsCommand_CanExecute()
        {
            return true;
        }
        public void ShowSettingsCommand_Execute()
        {
            if (ShowSettings)
            {
                ShowSettings = false;
            }
            else
            {
                ShowSettings = true;
            }
        }

        // 設定画面キャンセルボタン
        public ICommand SettingsCancelCommand { get; }
        public bool SettingsCancelCommand_CanExecute()
        {
            return true;
        }
        public void SettingsCancelCommand_Execute()
        {
            ShowSettings = false;
        }

        // 設定画面OKボタン
        public ICommand SettingsOKCommand { get; }
        public bool SettingsOKCommand_CanExecute()
        {
            return true;
        }
        public void SettingsOKCommand_Execute()
        {
            ShowSettings = false;
        }

        #endregion

    }
}
