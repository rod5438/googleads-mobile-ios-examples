//  Copyright (c) 2014 Google. All rights reserved.

@import GoogleMobileAds;

#import "ViewController.h"

#define defaultAdUnitId @"/6499/example/banner"
#define defaultAdWidth 320
#define defaultAdHeight 50

@interface ViewController() <GADBannerViewDelegate>

@property (nonatomic) IBOutlet UITextField *adUnitIdField;
@property (nonatomic) IBOutlet UITextField *adWidthField;
@property (nonatomic) IBOutlet UITextField *adHeightField;
@property (nonatomic) IBOutlet UITextView *errorLogTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerView.layer.borderColor = [[UIColor yellowColor] CGColor];
    self.bannerView.layer.borderWidth = 2.0f;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    [self refineSizeTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickLoadRequestButton:(UIButton *)sender
{
    self.bannerView.adUnitID = self.adUnitIdField.text.length!=0 ? self.adUnitIdField.text : defaultAdUnitId;
    CGSize adSize = [self refineSizeTextField];
    CGRect rect = CGRectMake((self.view.frame.size.width - adSize.width)/2, 60, adSize.width, adSize.height);
    self.bannerView.frame = rect;
    [self.bannerView loadRequest:[DFPRequest request]];
}

- (CGSize)refineSizeTextField
{
    NSInteger adWidth = self.adWidthField.text.length!=0 ? [self.adWidthField.text integerValue] : defaultAdWidth;
    NSInteger adHeight = self.adHeightField.text.length!=0 ? [self.adHeightField.text integerValue] : defaultAdHeight;
    self.adWidthField.text = [[NSString alloc] initWithFormat:@"%ld", (long)adWidth];
    self.adHeightField.text = [[NSString alloc] initWithFormat:@"%ld", (long)adHeight];
    return CGSizeMake(adWidth, adHeight);
}

#pragma mark GADBannerViewDelegate

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self.errorLogTextView setText:[error localizedDescription]];
}

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    [self.errorLogTextView setText:@"adViewDidReceiveAd"];
}
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
}

- (IBAction)onEndOfEdit:(UITextField *)testfield
{
    [testfield resignFirstResponder];
    [self refineSizeTextField];
}

@end
