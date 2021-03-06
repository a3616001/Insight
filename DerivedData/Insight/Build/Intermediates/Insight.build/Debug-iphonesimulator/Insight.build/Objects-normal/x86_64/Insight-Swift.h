// Generated by Apple Swift version 1.2 (swiftlang-602.0.53.1 clang-602.0.53)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
#if __has_feature(nullability)
#  define SWIFT_NULLABILITY(X) X
#else
# if !defined(__nonnull)
#  define __nonnull
# endif
# if !defined(__nullable)
#  define __nullable
# endif
# if !defined(__null_unspecified)
#  define __null_unspecified
# endif
#  define SWIFT_NULLABILITY(X)
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import CoreGraphics;
@import Photos;
@import QuartzCore;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;
@class NSObject;

SWIFT_CLASS("_TtC7Insight11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic) UIWindow * __nullable window;
- (BOOL)application:(UIApplication * __nonnull)application didFinishLaunchingWithOptions:(NSDictionary * __nullable)launchOptions;
- (void)applicationWillResignActive:(UIApplication * __nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * __nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * __nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * __nonnull)application;
- (void)applicationWillTerminate:(UIApplication * __nonnull)application;
- (SWIFT_NULLABILITY(nonnull) instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIImageView;
@class NSCoder;

SWIFT_CLASS("_TtC7Insight20ISCollectionViewCell")
@interface ISCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView * __null_unspecified contentImage;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class PHFetchResult;
@class ISPopSelectView;
@class UICollectionView;
@class NSIndexPath;
@class UICollectionViewLayout;
@class UITableView;
@class UITableViewCell;
@class UIBarButtonItem;
@class UIStoryboardSegue;

SWIFT_CLASS("_TtC7Insight26ISCollectionViewController")
@interface ISCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic) PHFetchResult * __nonnull allPhotos;
@property (nonatomic) PHFetchResult * __nonnull smartAlbums;
@property (nonatomic) PHFetchResult * __nonnull userAlbums;
@property (nonatomic) PHFetchResult * __nonnull nowFetchResult;
@property (nonatomic) ISPopSelectView * __nonnull popSelectView;
- (void)awakeFromNib;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView * __nonnull)collectionView;
- (NSInteger)collectionView:(UICollectionView * __nonnull)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell * __nonnull)collectionView:(UICollectionView * __nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (CGSize)collectionView:(UICollectionView * __nonnull)collectionView layout:(UICollectionViewLayout * __nonnull)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (CGFloat)collectionView:(UICollectionView * __nonnull)collectionView layout:(UICollectionViewLayout * __nonnull)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView * __nonnull)collectionView layout:(UICollectionViewLayout * __nonnull)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (UIEdgeInsets)collectionView:(UICollectionView * __nonnull)collectionView layout:(UICollectionViewLayout * __nonnull)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

/// ////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView * __nonnull)tableView;
- (UITableViewCell * __nonnull)tableView:(UITableView * __nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (NSInteger)tableView:(UITableView * __nonnull)tableView numberOfRowsInSection:(NSInteger)section;

/// ////////////////////////
- (void)tableView:(UITableView * __nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
@property (nonatomic) BOOL visiable;
- (IBAction)pressSelectButton:(UIBarButtonItem * __nonnull)sender;
- (void)update;
- (void)prepareForSegue:(UIStoryboardSegue * __nonnull)segue sender:(id __nullable)sender;
@end

@class CIContext;
@class CIImage;

SWIFT_CLASS("_TtC7Insight20ISColorHistogramView")
@interface ISColorHistogramView : UIView
@property (nonatomic, copy) NSArray * __null_unspecified data;
@property (nonatomic) CIContext * __null_unspecified context;
- (CGImageRef __nonnull)CIImageToCGImage:(CIImage * __nonnull)image;
- (void)drawRect:(CGRect)rect;
- (void)update:(CIImage * __nonnull)newImage;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UILabel;
@class UISlider;
@class UIButton;
@class PHAsset;
@class ToneCurveEditor;
@class UIGestureRecognizer;
@class UIPinchGestureRecognizer;
@class UIRotationGestureRecognizer;
@class UIPanGestureRecognizer;
@class UITapGestureRecognizer;
@class PHChange;
@class UIImage;
@class UIVisualEffectView;
@class NSLayoutConstraint;

SWIFT_CLASS("_TtC7Insight24ISDarkroomViewController")
@interface ISDarkroomViewController : UIViewController <UIGestureRecognizerDelegate, PHPhotoLibraryChangeObserver>
@property (nonatomic, weak) IBOutlet UIView * __null_unspecified imageContainerView;
@property (nonatomic, weak) IBOutlet UIImageView * __null_unspecified imageView;
@property (nonatomic, weak) IBOutlet UIVisualEffectView * __null_unspecified mainFunctionView;
@property (nonatomic, weak) IBOutlet UIVisualEffectView * __null_unspecified subFunctionView;
@property (nonatomic, weak) IBOutlet UIVisualEffectView * __null_unspecified adjustBarView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * __null_unspecified functionContainerViewConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * __null_unspecified mainFunctionViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * __null_unspecified subFunctionViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * __null_unspecified adjustBarViewHeightConstraint;
@property (nonatomic) ISCollectionViewController * __null_unspecified collectionViewController;
@property (nonatomic) UILabel * __null_unspecified adjustBarLabelView;
@property (nonatomic) UISlider * __null_unspecified adjustBarSliderView;
@property (nonatomic, copy) NSArray * __nonnull mainFunctionButtons;
@property (nonatomic, copy) NSArray * __nonnull subFunctionButtons;
@property (nonatomic, copy) NSArray * __null_unspecified subFunctionButtonTitles;
@property (nonatomic, copy) NSString * __null_unspecified nowFunction;
@property (nonatomic) PHAsset * __null_unspecified asset;
@property (nonatomic) CIImage * __null_unspecified originalImage;
@property (nonatomic) CIImage * __null_unspecified originalThumbnail;
@property (nonatomic) CIImage * __null_unspecified thumbnail;
@property (nonatomic) CIContext * __null_unspecified context;
@property (nonatomic) ISColorHistogramView * __null_unspecified colorHistogramView;
@property (nonatomic) ToneCurveEditor * __null_unspecified toneCurveView;

/// /////////////////
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)viewDidLoad;
- (void)initializeContent;

/// ///////////////
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer * __nonnull)recognizer;
- (void)pinchGestureDetected:(UIPinchGestureRecognizer * __nonnull)recognizer;
- (void)rotationGestureDetected:(UIRotationGestureRecognizer * __nonnull)recognizer;
- (void)panGestureDetected:(UIPanGestureRecognizer * __nonnull)recognizer;
- (void)doubleTabGestureDetected:(UITapGestureRecognizer * __nonnull)recognizer;

/// double tap slider to set default argument
- (void)sliderDoubleTabGestureDetected:(UITapGestureRecognizer * __nonnull)recognizer;
- (BOOL)gestureRecognizer:(UIGestureRecognizer * __nonnull)recongizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer * __nonnull)otherGestureRecognizer;

/// ////////////
- (void)mainFunctionButtonPressed:(UIButton * __nonnull)sender;
- (void)subFunctionButtonPressed:(UIButton * __nonnull)sender;
- (IBAction)recoverButtonPressed:(UIBarButtonItem * __nonnull)sender;
- (IBAction)saveButtonPressed:(UIBarButtonItem * __nonnull)sender;
- (void)switchToSubFunction:(NSInteger)num;

/// ////////////
- (void)adjustBarSliderChanged:(UISlider * __nonnull)sender;
- (void)toneCurveViewSliderChanged:(ToneCurveEditor * __nonnull)toneCurveView;
- (void)toneCurveViewSlidesDidChange:(ToneCurveEditor * __nonnull)toneCurveView;
- (void)photoLibraryDidChange:(PHChange * __null_unspecified)changeInstance;

/// ///////////////////
- (void)refreshAdjustBar;
- (void)refreshImage;
- (void)refreshHistogram;
- (void)refreshToneCurveView;

/// ///////////
- (float)argumentValueToSliderValue:(NSString * __nonnull)argumentName;
- (double)sliderValueToArgumentValue:(NSString * __nonnull)argumentName;
- (CIImage * __nonnull)resizeImage:(CIImage * __nonnull)image ratio:(float)ratio;
- (UIImage * __nonnull)imageWithSize:(UIImage * __nonnull)image size:(CGSize)size;
- (UIImage * __nonnull)CIImageToUIImage:(CIImage * __nonnull)image;
- (void)didReceiveMemoryWarning;
@end


SWIFT_CLASS("_TtC7Insight15ISPopSelectView")
@interface ISPopSelectView : UITableView
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class ToneCurveEditorCurveLayer;

SWIFT_CLASS("_TtC7Insight15ToneCurveEditor")
@interface ToneCurveEditor : UIControl
@property (nonatomic, copy) NSArray * __nonnull sliders;
@property (nonatomic, readonly) ToneCurveEditorCurveLayer * __null_unspecified curveLayer;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, copy) NSArray * __nonnull curveValues;
- (void)createSliders;
- (void)drawCurve;
- (void)sliderChangeHandler:(UISlider * __nonnull)slider;
- (void)layoutSubviews;
@end


SWIFT_CLASS("_TtC7Insight25ToneCurveEditorCurveLayer")
@interface ToneCurveEditorCurveLayer : CALayer
@property (nonatomic, weak) ToneCurveEditor * __nullable toneCurveEditor;
- (void)drawInContext:(CGContextRef __null_unspecified)ctx;
- (SWIFT_NULLABILITY(null_unspecified) instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(null_unspecified) instancetype)initWithLayer:(id __null_unspecified)layer OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface UIBezierPath (SWIFT_EXTENSION(Insight))
@end

#pragma clang diagnostic pop
