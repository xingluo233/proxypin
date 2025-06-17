// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get requests => '抓包';

  @override
  String get favorites => '收藏';

  @override
  String get history => '历史';

  @override
  String get toolbox => '工具箱';

  @override
  String get me => '我的';

  @override
  String get preference => '偏好设置';

  @override
  String get feedback => '反馈';

  @override
  String get about => '关于';

  @override
  String get filter => '代理过滤';

  @override
  String get script => '脚本';

  @override
  String get share => '分享';

  @override
  String get port => '端口号: ';

  @override
  String get proxy => '代理';

  @override
  String get externalProxy => '外部代理设置';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get proxySetting => '代理设置';

  @override
  String get systemProxy => '设置为系统代理';

  @override
  String get enabledHTTP2 => '启用HTTP2';

  @override
  String get serverNotStart => '未开启抓包';

  @override
  String get download => '下载';

  @override
  String get start => '开始';

  @override
  String get stop => '停止';

  @override
  String get clear => '清空';

  @override
  String get httpsProxy => 'HTTPS 代理';

  @override
  String get setting => '设置';

  @override
  String get mobileConnect => '手机连接';

  @override
  String get connectRemote => '连接终端';

  @override
  String get remoteDevice => '远程设备';

  @override
  String get remoteDeviceList => '远程设备列表';

  @override
  String get myQRCode => '我的二维码';

  @override
  String get theme => '主题';

  @override
  String get followSystem => '跟随系统';

  @override
  String get themeColor => '主题颜色';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get language => '语言';

  @override
  String get autoStartup => '自动开启抓包';

  @override
  String get autoStartupDescribe => '程序启动时自动开始记录流量';

  @override
  String get copied => '已复制到剪贴板';

  @override
  String get cancel => '取消';

  @override
  String get close => '关闭';

  @override
  String get save => '保存';

  @override
  String get confirm => '确认';

  @override
  String get confirmTitle => '确认操作';

  @override
  String get confirmContent => '是否确认此操作?';

  @override
  String get addSuccess => '添加成功';

  @override
  String get saveSuccess => '保存成功';

  @override
  String get operationSuccess => '操作成功';

  @override
  String get import => '导入';

  @override
  String get importSuccess => '导入成功';

  @override
  String get importFailed => '导入失败';

  @override
  String get export => '导出';

  @override
  String get exportSuccess => '导出成功';

  @override
  String get deleteSuccess => '删除成功';

  @override
  String get send => '发送';

  @override
  String get fail => '失败';

  @override
  String get success => '成功';

  @override
  String get emptyData => '无数据';

  @override
  String get requestSuccess => '请求成功';

  @override
  String get add => '添加';

  @override
  String get all => '全部';

  @override
  String get modify => '修改';

  @override
  String get responseType => '响应类型';

  @override
  String get request => '请求';

  @override
  String get response => '响应';

  @override
  String get statusCode => '状态码';

  @override
  String get done => '完成';

  @override
  String get type => '类型';

  @override
  String get enable => '启用';

  @override
  String get example => '示例: ';

  @override
  String get responseHeader => '响应头';

  @override
  String get requestHeader => '请求头';

  @override
  String get requestLine => '请求行';

  @override
  String get requestMethod => '请求方法';

  @override
  String get param => '参数';

  @override
  String get replaceBodyWith => '消息体替换为:';

  @override
  String get redirectTo => '重定向到:';

  @override
  String get redirect => '重定向';

  @override
  String get cannotBeEmpty => '不能为空';

  @override
  String get requestRewriteList => '请求重写列表';

  @override
  String get requestRewriteRule => '请求重写规则';

  @override
  String get requestRewriteEnable => '是否启用请求重写';

  @override
  String get action => '行为';

  @override
  String get multiple => '多选';

  @override
  String get edit => '编辑';

  @override
  String get disabled => '禁用';

  @override
  String requestRewriteDeleteConfirm(Object size) {
    return '是否删除$size条规则?';
  }

  @override
  String get useGuide => '使用文档';

  @override
  String get pleaseEnter => '请输入';

  @override
  String get click => '点击';

  @override
  String get replace => '替换';

  @override
  String get clickEdit => '点击编辑';

  @override
  String get refresh => '刷新';

  @override
  String get selectFile => '选择文件';

  @override
  String get match => '匹配';

  @override
  String get value => '值';

  @override
  String get matchRule => '匹配规则';

  @override
  String get emptyMatchAll => '为空表示匹配全部';

  @override
  String get newBuilt => '新建';

  @override
  String get newFolder => '新建文件夹';

  @override
  String get enableSelect => '启用选择';

  @override
  String get disableSelect => '禁用选择';

  @override
  String get deleteSelect => '删除选择';

  @override
  String get testData => '测试数据';

  @override
  String get noChangesDetected => '未检测到变更';

  @override
  String get enterMatchData => '输入待匹配的数据';

  @override
  String get modifyRequestHeader => '修改请求头';

  @override
  String get headerName => '请求头名称';

  @override
  String get headerValue => '请求头值';

  @override
  String get deleteHeaderConfirm => '是否删除该请求头';

  @override
  String get sequence => '全部请求';

  @override
  String get domainList => '域名列表';

  @override
  String get domainWhitelist => '代理域名白名单';

  @override
  String get domainBlacklist => '代理域名黑名单';

  @override
  String get domainFilter => '域名代理列表';

  @override
  String get appWhitelist => '应用白名单';

  @override
  String get appWhitelistDescribe => '只代理白名单中的应用, 白名单启用黑名单将会失效';

  @override
  String get appBlacklist => '应用黑名单';

  @override
  String get scanCode => '扫码连接';

  @override
  String get addBlacklist => '添加代理黑名单';

  @override
  String get addWhitelist => '添加代理白名单';

  @override
  String get deleteWhitelist => '删除代理白名单';

  @override
  String domainListSubtitle(Object count, Object time) {
    return '最后请求时间: $time,  次数: $count';
  }

  @override
  String get selectAction => '选择操作';

  @override
  String get copy => '复制';

  @override
  String get copyHost => '复制域名';

  @override
  String get copyUrl => '复制URL';

  @override
  String get copyRequestResponse => '复制 请求和响应';

  @override
  String get copyCurl => '复制 cURL';

  @override
  String get copyAsPythonRequests => '复制 Python Requests';

  @override
  String get delete => '删除';

  @override
  String get rename => '重命名';

  @override
  String get repeat => '重放';

  @override
  String get repeatAllRequests => '重放所有请求';

  @override
  String get repeatDomainRequests => '重放域名下请求';

  @override
  String get customRepeat => '高级重放';

  @override
  String get repeatCount => '次数';

  @override
  String get repeatInterval => '间隔(ms)';

  @override
  String get repeatDelay => '延时(ms)';

  @override
  String get scheduleTime => '指定时间';

  @override
  String get fixed => '固定';

  @override
  String get random => '随机';

  @override
  String get keepCustomSettings => '保持自定义设置';

  @override
  String get editRequest => '编辑请求';

  @override
  String get reSendRequest => '已重新发送请求';

  @override
  String get viewExport => '视图导出';

  @override
  String get timeDesc => '按时间降序';

  @override
  String get timeAsc => '按时间升序';

  @override
  String get search => '搜索';

  @override
  String get clearSearch => '清除搜索';

  @override
  String get requestType => '请求类型';

  @override
  String get keyword => '关键词';

  @override
  String get keywordSearchScope => '关键词搜索范围: ';

  @override
  String get favorite => '收藏';

  @override
  String get deleteFavorite => '删除收藏';

  @override
  String get emptyFavorite => '暂无收藏';

  @override
  String get deleteFavoriteSuccess => '已删除收藏';

  @override
  String get name => '名称';

  @override
  String get historyRecord => '历史记录';

  @override
  String get historyCacheTime => '缓存时间';

  @override
  String get historyManualSave => '手动保存';

  @override
  String historyDay(Object day) {
    return '$day天';
  }

  @override
  String get historyForever => '永久';

  @override
  String historyRecordTitle(Object length, Object name) {
    return '$name 记录数 $length';
  }

  @override
  String get historyEmptyName => '名称不能为空';

  @override
  String historySubtitle(Object requestLength, Object size) {
    return '记录数 $requestLength  文件 $size';
  }

  @override
  String get historyUnSave => '当前会话记录未保存';

  @override
  String get historyDeleteConfirm => '是否删除该历史记录？';

  @override
  String get requestEdit => '请求编辑';

  @override
  String get encode => '编码';

  @override
  String get requestBody => '请求体';

  @override
  String get responseBody => '响应体';

  @override
  String get requestRewrite => '请求重写';

  @override
  String get newWindow => '新窗口打开';

  @override
  String get httpRequest => 'HTTP请求';

  @override
  String get enabledHttps => '启用HTTPS代理';

  @override
  String get installRootCa => '安装根证书';

  @override
  String get installCaLocal => '安装根证书到本机';

  @override
  String get downloadRootCa => '下载根证书';

  @override
  String get downloadRootCaNote => '注意：如果您将默认浏览器设置为 Safari 以外的浏览器，请单击此行复制并粘贴 Safari 浏览器的链接';

  @override
  String get generateCA => '重新生成根证书';

  @override
  String get generateCADescribe => '您确定要生成新的根证书吗? 如果确认，\n则需要重新安装并信任新的证书';

  @override
  String get resetDefaultCA => '重置默认根证书';

  @override
  String get resetDefaultCADescribe => '确定要重置为默认根证书吗? ProxyPin默认\n根证书对所有用户都是相同的.';

  @override
  String get exportCaP12 => '导出根证书 (.p12)';

  @override
  String get importCaP12 => '导入根证书 (.p12)';

  @override
  String get trustCa => '信任证书';

  @override
  String get profileDownload => '已下载描述文件';

  @override
  String get exportCA => '导出根证书';

  @override
  String get exportPrivateKey => '导出私钥';

  @override
  String get install => '安装';

  @override
  String get installCaDescribe => '安装证书 设置 > 已下载描述文件 > 安装';

  @override
  String get trustCaDescribe => '信任证书 设置 > 通用 > 关于本机 > 证书信任设置';

  @override
  String get androidRoot => '系统证书 (ROOT设备)';

  @override
  String get androidRootMagisk =>
      'Magisk模块: \n安卓ROOT设备可以使用Magisk ProxyPinCA系统证书模块, 安装完重启手机后 在系统证书查看是否有ProxyPinCA证书，如果有说明证书安装成功。';

  @override
  String androidRootRename(Object name) {
    return '模块不生效可以根据网上教程安装系统根证书, 根证书命名成 $name';
  }

  @override
  String get androidRootCADownload => '下载系统根证书(.0)';

  @override
  String get androidUserCA => '用户证书';

  @override
  String get androidUserCATips => '提示：Android7+ 很多软件不会信任用户证书';

  @override
  String get androidUserCAInstall => '打开设置 -> 安全 -> 加密和凭据 -> 安装证书 -> CA 证书';

  @override
  String get androidUserXposed => '推荐使用Xposed模块抓包(无需ROOT), 点击查看wiki';

  @override
  String get configWifiProxy => '配置手机Wi-Fi代理';

  @override
  String get caInstallGuide => '证书安装指南';

  @override
  String get caAndroidBrowser => '在 Android 设备上打开浏览器访问：';

  @override
  String get caIosBrowser => '在 iOS 设备上打开 Safari访问：';

  @override
  String get localIP => '本地IP ';

  @override
  String get mobileScan => '配置Wi-Fi代理或使用手机版扫描二维码';

  @override
  String get decode => '解码';

  @override
  String get encodeInput => '输入要转换的内容';

  @override
  String get encodeResult => '转换结果';

  @override
  String get encodeFail => '编码失败';

  @override
  String get decodeFail => '解码失败';

  @override
  String get shareUrl => '分享请求链接';

  @override
  String get shareCurl => '分享 cURL 请求';

  @override
  String get shareRequestResponse => '分享请求和响应';

  @override
  String get captureDetail => '抓包详情';

  @override
  String get proxyPinSoftware => 'ProxyPin全平台开源抓包软件';

  @override
  String get prompt => '提示';

  @override
  String get curlSchemeRequest => '识别到curl格式，是否转换为HTTP请求？';

  @override
  String get appExitTips => '再按一次退出程序';

  @override
  String get remoteConnectDisconnect => '检查远程连接失败，已断开';

  @override
  String get reconnect => '重新连接';

  @override
  String remoteConnected(Object os) {
    return '已连接$os，流量将转发到$os';
  }

  @override
  String get remoteConnectForward => '远程连接，将其他设备流量转发到当前设备';

  @override
  String get connectSuccess => '连接成功';

  @override
  String get connectedRemote => '已连接远程';

  @override
  String get connected => '已连接';

  @override
  String get notConnected => '未连接';

  @override
  String get disconnect => '断开连接';

  @override
  String get ipLayerProxy => 'IP层代理(Beta)';

  @override
  String get ipLayerProxyDesc => 'IP层代理可抓取Flutter应用请求，目前不是很稳定,欢迎提交PR';

  @override
  String get inputAddress => '输入地址';

  @override
  String get syncConfig => '同步配置';

  @override
  String get pullConfigFail => '拉取配置失败, 请检查网络连接';

  @override
  String get sync => '同步';

  @override
  String get invalidQRCode => '无法识别的二维码';

  @override
  String get remoteConnectFail => '连接失败，请检查是否在同一局域网和防火墙是否允许, ios需要开启本地网络权限';

  @override
  String get remoteConnectSuccessTips => '手机需要开启抓包才可以抓取请求哦';

  @override
  String get windowMode => '窗口模式';

  @override
  String get windowModeSubTitle => '开启抓包后 如果应用退回到后台，显示一个小窗口';

  @override
  String get pipIcon => '窗口快捷图标';

  @override
  String get pipIconDescribe => '展示快捷进入小窗口Icon';

  @override
  String get headerExpanded => 'Headers自动展开';

  @override
  String get headerExpandedSubtitle => '详情页Headers栏是否自动展开';

  @override
  String get bottomNavigation => '底部导航';

  @override
  String get bottomNavigationSubtitle => '底部导航栏是否显示，重启后生效';

  @override
  String get memoryCleanup => '内存清理';

  @override
  String get memoryCleanupSubtitle => '到内存限制自动清理请求，清理后保留最近32条请求';

  @override
  String get unlimited => '无限制';

  @override
  String get custom => '自定义';

  @override
  String get externalProxyAuth => '代理认证 (可选)';

  @override
  String get externalProxyServer => '代理服务器';

  @override
  String get externalProxyConnectFailure => '外部代理连接失败';

  @override
  String get externalProxyFailureConfirm => '网络不通所有接口将会访问失败，是否继续设置外部代理。';

  @override
  String get mobileDisplayPacketCapture => '手机端是否展示抓包:';

  @override
  String proxyPortRepeat(Object port) {
    return '启动失败，请检查端口号$port是否被占用';
  }

  @override
  String get reset => '重置';

  @override
  String get proxyIgnoreDomain => '代理忽略域名';

  @override
  String get domainWhitelistDescribe => '只代理白名单中的域名, 白名单启用黑名单将会失效';

  @override
  String get domainBlacklistDescribe => '黑名单中的域名不会代理';

  @override
  String get domain => '域名';

  @override
  String get enableScript => '启用脚本工具';

  @override
  String get scriptUseDescribe => '使用 JavaScript 修改请求和响应';

  @override
  String get scriptEdit => '编辑脚本';

  @override
  String get scrollEnd => '跟踪滚动';

  @override
  String get logger => '日志';

  @override
  String get material3 => 'Material3是谷歌开源设计系统的最新版本';

  @override
  String get iosVpnBackgroundAudio => '开启抓包后，退出到后台。为了维护主UI线程的网络通信，将启用静音音频播放以保持主线程运行。否则，它将只在后台运行30秒。您同意在启用抓包后在后台播放音频吗?';

  @override
  String get markRead => '标记已读';

  @override
  String get autoRead => '自动已读';

  @override
  String get highlight => '高亮';

  @override
  String get blue => '蓝色';

  @override
  String get green => '绿色';

  @override
  String get yellow => '黄色';

  @override
  String get red => '红色';

  @override
  String get pink => '粉色';

  @override
  String get gray => '灰色';

  @override
  String get underline => '下划线';

  @override
  String get requestBlock => '请求屏蔽';

  @override
  String get other => '其他';

  @override
  String get certHashName => '证书Hash名称';

  @override
  String get regExp => '正则表达式';

  @override
  String get systemCertName => '系统证书名称';

  @override
  String get qrCode => '二维码';

  @override
  String get scanQrCode => '扫描二维码';

  @override
  String get generateQrCode => '生成二维码';

  @override
  String get saveImage => '保存图片';

  @override
  String get selectImage => '选择图片';

  @override
  String get inputContent => '输入内容';

  @override
  String get errorCorrectLevel => '纠错等级';

  @override
  String get output => '输出';

  @override
  String get timestamp => '时间戳';

  @override
  String get convert => '转换';

  @override
  String get time => '时间';

  @override
  String get nowTimestamp => '当前时间戳(秒)';

  @override
  String get hosts => 'Hosts 映射';

  @override
  String get toAddress => '映射地址';

  @override
  String get encrypt => '加密';

  @override
  String get decrypt => '解密';

  @override
  String get cipher => '加解密';

  @override
  String get appUpdateCheckVersion => '检查更新';

  @override
  String get appUpdateNotAvailableMsg => '已是最新版本';

  @override
  String get appUpdateDialogTitle => '有可用更新';

  @override
  String get appUpdateUpdateMsg => 'ProxyPin 的新版本现已推出。您想现在更新吗？';

  @override
  String get appUpdateCurrentVersionLbl => '当前版本';

  @override
  String get appUpdateNewVersionLbl => '新版本';

  @override
  String get appUpdateUpdateNowBtnTxt => '现在更新';

  @override
  String get appUpdateLaterBtnTxt => '以后再说';

  @override
  String get appUpdateIgnoreBtnTxt => '忽略';
}
