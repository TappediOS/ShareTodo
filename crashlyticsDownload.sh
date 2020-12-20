# carthageでcrashlyticsを管理する場合は別途uploadとrunを落とす必要がある

curl -L https://github.com/firebase/firebase-ios-sdk/raw/master/Crashlytics/upload-symbols -o FirebaseCrashlytics/upload-symbols
curl -L https://github.com/firebase/firebase-ios-sdk/raw/master/Crashlytics/run -o FirebaseCrashlytics/run
chmod 755 FirebaseCrashlytics/*


