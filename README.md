# CCFPSStatus

[CCFPSStatus](https://github.com/ccworld1000/CCFPSStatus) show FPS status | Flexible location (Built-in on [JPFPSStatus](https://github.com/joggerplus/JPFPSStatus), optimize and adjust it)



## Screenshots

![CCFPSStatus fps](https://github.com/ccworld1000/CCFPSStatus/blob/master/fps.gif?raw=true)



#### Podfile

```ruby
platform :ios, '9.0'
pod 'CCFPSStatus'
```

#### Instruction
Note：Use CCFPSStatus in DEBUG mode

add the code in AppDelegate.m    

<pre>
#import "CCFPSStatus.h"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#if defined(DEBUG)||defined(_DEBUG)
    [[CCFPSStatus sharedInstance] open];
#endif
    return YES;
}
</pre>

<pre>
#if defined(DEBUG)||defined(_DEBUG)
	[[CCFPSStatus sharedInstance] openWithHandler:^(NSInteger fpsValue) {
		NSLog(@"fpsvalue %@",@(fpsValue));
	}];
#endif
</pre>


<pre>
#if defined(DEBUG)||defined(_DEBUG)
    [[CCFPSStatus sharedInstance] close];
#endif
</pre>

#### Licenses

All source code is licensed under the [MIT License](https://github.com/ccworld1000/CCFPSStatus/blob/master/LICENSE).
