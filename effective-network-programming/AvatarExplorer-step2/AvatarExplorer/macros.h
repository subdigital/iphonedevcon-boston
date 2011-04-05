/*
 *  Macros.h
 *  bizeeti-iphone
 *
 *  Created by Ben Scheirman on 10/6/10.
 */

//From Nathan Eror
#pragma mark -
#pragma mark iOS 4 Version Checkers

#define IS_IOS4 ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"4"])

#pragma mark -
#pragma mark Logging

/*!
 @def LOG(...)
 A simple wrapper for NSLog() that is automatically removed from release builds.
 */

/*!
 @def LOGEXT(fmt, ...)
 More detailed loogging. Logs the function name and line number after the log message.
 */

/*!
 @def LOGCALL
 Logs a method call's class and selector.
 */

// LOGEXT logging macro from: http://iphoneincubator.com/blog/debugging/the-evolution-of-a-replacement-for-nslog
#ifdef DEBUG
#define LOG(...) NSLog(__VA_ARGS__)
#define LOGEXT(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define LOGCALL LOG(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#define LOG(...) /* */
#define LOGEXT(...) /* */
#define LOGCALL /* */
#endif
//@}

/*! @name Memory Management */
//@{
#pragma mark -
#pragma mark Memory Management

/*!
 Safely release an objective-c object and set its variable to nil.
 */
#define RELEASE(_obj) [_obj release], _obj = nil


#pragma mark -
#pragma mark Math

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#define RADIANS_TO_DEGREES(r) (r * 180 / M_PI)

//@}

/*!
 @name Colors
 */
//@{
#pragma mark -
#pragma mark Colors

/*!
 Create a UIColor with r,g,b values between 0.0 and 1.0.
 */
//#define RGBCOLOR(r,g,b) \
//[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:1.f]

/*!
 Create a UIColor with r,g,b,a values between 0.0 and 1.0.
 */
//#define RGBACOLOR(r,g,b,a) \
//[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:a]

/*!
 Create a UIColor from a hex value. For example, UIColorFromRGB(0xFF0000) creates a UIColor object representing the color red.
 */
#define UIColorFromRGB(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

/*!
 Create a UIColor with an alpha value from a hex value.
 
 For example, UIColorFromRGBA(0xFF0000, .5) creates a UIColor object representing a half-transparent red. 
 */
#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]
//@}


/*! @name File System */
//@{
#pragma mark -
#pragma mark File System

/*!
 Get the full path for a file name in the documents directory.
 @param filename the name of the file <em>(the file need not exist yet)</em>.
 @return The full path to the filename.
 */
static inline NSString *PathForFileInDocumentsDirectory(NSString *filename) {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
	return path;
}
//@}


#pragma mark -
#pragma mark Rect Manipulation

static inline void RepositionViewFrame(UIView *v, CGFloat newX, CGFloat newY) {
	CGRect rect = v.frame;
	rect.origin.x = newX;
	rect.origin.y = newY;
	v.frame = rect;
}

static inline void ResizeViewFrame(UIView *v, CGFloat newWidth, CGFloat newHeight) {
	CGRect rect = v.frame;
	rect.size.width = newWidth;
	rect.size.height = newHeight;
	v.frame = rect;
}

static inline void MoveViewFrame(UIView *v, CGFloat deltaX, CGFloat deltaY) {
	CGRect rect = v.frame;
	rect.origin.x += deltaX;
	rect.origin.y += deltaY;
	v.frame = rect;
}

static inline void GrowViewFrame(UIView *v, CGFloat deltaWidth, CGFloat deltaHeight) {
	CGRect rect = v.frame;
	rect.size.width += deltaWidth;
	rect.size.height += deltaHeight;
	v.frame = rect;
}



#ifdef __OBJC__


//From Wil Shipley
static inline BOOL isEmpty(id thing) {
	return thing == nil
	|| ([thing respondsToSelector:@selector(length)]
		&& [(NSData *)thing length] == 0)
	|| ([thing respondsToSelector:@selector(count)]
		&& [(NSArray *)thing count] == 0);
}
#endif


//For debugging views
#define OUTLINE(view) self.view.layer.borderWidth = 2; self.view.layer.borderColor = [[UIColor redColor] CGColor];
#define OUTLINE_RECT(rect) \
CGContextRef __context__ = UIGraphicsGetCurrentContext();  \
CGContextSaveGState(__context__);  \
CGContextSetStrokeColorWithColor(__context__, [[UIColor blueColor] CGColor]); \
CGContextStrokeRect(__context__, rect); \
CGContextRestoreGState(__context__);


#define EXPAND_TO_VA_ARGS(array) \
[array count] == 0 ? nil : \
[array count] == 1 ? [array objectAtIndex:0], nil : \
[array count] == 2 ? [array objectAtIndex:0], [array objectAtIndex:1], nil : \
[array count] == 3 ? [array objectAtIndex:0], [array objectAtIndex:1], [array objectAtIndex:2], nil : \
[array objectAtIndex:0], [array objectAtIndex:1], [array objectAtIndex:2], [array objectAtIndex:3], nil 

