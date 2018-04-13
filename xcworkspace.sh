#注意：\
    1.脚本目录和xxxx.xcodeproj要在同一个目录，如果放到其他目录，路径会发生错，请自行修改脚本。\
    2.在对应的plist文件中修改对应的value值，例如：method 包含四种： app-store, ad-hoc, enterprise, development ; 如果不会写plist文件，就手动打包，将打包后的plist文件拷贝过来使用 \
    3.在脚本文件中修改对应的参数 \
    4.证书名在:钥匙串-显示内容-常用描述文件可以使用描述文件的UUID打包时可获取，也可以是文件名 \
    5.使用，使用终端进入到当前文件夹，运行.sh ./脚本名.sh 脚本文件
#

#工程名字(Target名字)
Project_Name="xxx"
#配置环境，Release或者Debug
Configuration="Release"

#AppStore版本的Bundle ID
BundleID_AppStore="com.csc.xxx"
#AdHoc版本的Bundle ID
BundleID_AdHoc="com.csc.xxx"
#enterprise的Bundle ID
BundleID_Enterprise="com.csc.xxx"

#AppStore证书名#描述文件
CODE_SIGN_IDENTITY_APPSTORE="iPhone Distribution: xxx"
PROVISIONING_PROFILE_NAME_APPSTORE="xxx"

#ADHOC证书名#描述文件
CODE_SIGN_IDENTITY_ADHOC="iPhone Distribution: xxx"
PPROVISIONING_PROFILE_NAME_ADHOC="xxx"

#企业(enterprise)证书名#描述文件
CODE_SIGN_IDENTITY_ENTERPRISE="iPhone Distribution: xxxx"
PROVISIONING_PROFILE_NAME_ENTERPRISE="xxx"

#加载各个版本的plist文件，
ExportOptionsPlist_AppStore=./ExportOptions_AppStore.plist
ExportOptionsPlist_ADHOC=./ExportOptions_ADHOC.plist
ExportOptionsPlist_Enterprise=./ExportOptions_Enterpriseplist

ExportOptionsPlist_AppStore=${ExportOptionsPlist_AppStore}
ExportOptionsPlist_ADHOC=${ExportOptionsPlist_ADHOC}
ExportOptionsPlist_Enterprise=${ExportOptionsPlist_Enterprise}

echo "~~~~~~~~~~~~选择打包方式(输入序号)~~~~~~~~~~~~~~~"
echo "  1 appstore"
echo "  2 adhoc"
echo "  3 enterprise"

# 读取用户输入并存到变量里
read parameter
sleep 0.5
method="$parameter"

# 判读用户是否有输入
if [ -n "$method" ]
then

if [ "$method" = "1" ]
then
BundleID=${BundleID_AppStore}
CODE_SIGN_IDENTITY_Cer=${CODE_SIGN_IDENTITY_APPSTORE}
PROVISIONING_PROFILE_NAME_Profile=${PROVISIONING_PROFILE_NAME_APPSTORE}
ExportOptionsPlist=${ExportOptionsPlist_AppStore}
ProjectFile_Name=${Project_Name}-appstore
elif [ "$method" = "2" ]
then
BundleID=${BundleID_AdHoc}
CODE_SIGN_IDENTITY_Cer=${CODE_SIGN_IDENTITY_ADHOC}
PROVISIONING_PROFILE_NAME_Profile=${PROVISIONING_PROFILE_NAME_ADHOC}
ExportOptionsPlist=${ExportOptionsPlist_ADHOC}
ProjectFile_Name=${Project_Name}-adhoc
elif [ "$method" = "3" ]
then
BundleID=${BundleID_Enterprise}
CODE_SIGN_IDENTITY_Cer=${CODE_SIGN_IDENTITY_ENTERPRISE}
PROVISIONING_PROFILE_NAME_Profile=${PROVISIONING_PROFILE_NAME_ENTERPRISE}
ExportOptionsPlist=${ExportOptionsPlist_Enterprise}
ProjectFile_Name=${Project_Name}-enterprise
else
echo "参数无效...."
exit 1
fi

xcodebuild \
-workspace $Project_Name.xcworkspace \
-scheme $Project_Name \
-configuration $Configuration \
-archivePath build/$ProjectFile_Name.xcarchive \
clean archive build  \
CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY_Cer}" \
PROVISIONING_PROFILE="${PROVISIONING_PROFILE_NAME_Profile}" \
PRODUCT_BUNDLE_IDENTIFIER="${BundleID}"

ls_date=`date +%Y-%m-%d`
exportPath=~/Desktop/${ProjectFile_Name}-${ls_date}
xcodebuild \
-exportArchive \
-archivePath build/$ProjectFile_Name.xcarchive \
-exportOptionsPlist $ExportOptionsPlist \
-exportPath $exportPath
fi
