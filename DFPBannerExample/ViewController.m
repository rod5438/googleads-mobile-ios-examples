//  Copyright (c) 2014 Google. All rights reserved.

@import GoogleMobileAds;

#import "ViewController.h"
#import "DeviceInfoUtility.h"

#define defaultAdUnitId @"/6499/example/banner"
#define defaultAdWidth 320
#define defaultAdHeight 50
#define defaultSampleJSONString @"{\"banner_country\":\"zh_TW\",\"version\":\"4.8.0\"}"

@interface ViewController() <GADBannerViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) IBOutlet UITextField *adUnitIdField;
@property (nonatomic) IBOutlet UITextField *adWidthField;
@property (nonatomic) IBOutlet UITextField *adHeightField;
@property (nonatomic) IBOutlet UITextField *languageCodeField;
@property (nonatomic) IBOutlet UITextView *errorLogTextView;
@property (nonatomic) IBOutlet UITextView *customTargetingJSONView;
@property (nonatomic) IBOutlet UISwitch *customTargetingSwitch;
@property (nonatomic) IBOutlet UIPickerView *adUnitIdPickerView;
@property (nonatomic) NSMutableArray *adUnitIds;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerView.layer.borderColor = [[UIColor yellowColor] CGColor];
    self.bannerView.layer.borderWidth = 2.0f;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    [self refineSizeTextField];
    self.adUnitIds = [[NSMutableArray alloc] initWithArray:@[@{@"friendlyName":@"default",
                                                               @"adUnitId":@"",
                                                               @"Width":@"320",
                                                               @"Height":@"50"},
                                                             @{@"friendlyName":@"Google Sample",
                                                               @"adUnitId":@"/6499/example/banner",
                                                               @"Width":@"320",
                                                               @"Height":@"50"},
                                                             @{@"friendlyName":@"YouCamPerfect tile",
                                                               @"adUnitId":@"/14662192/youcamperfect-ios-main-tile-1",
                                                               @"Width":@"88",
                                                               @"Height":@"88"},
                                                             @{@"friendlyName":@"YouCamPerfect tile test",
                                                               @"adUnitId":@"/14662192/youcamperfect-ios-main-tile-1-test",
                                                               @"Width":@"88",
                                                               @"Height":@"88"},
                                                             @{@"friendlyName":@"Rotate test(88*88)",
                                                               @"adUnitId":@"/14662192/youcamperfect-ios-main-tile-2-test",
                                                               @"Width":@"88",
                                                               @"Height":@"88"},
                                                             @{@"friendlyName":@"Rotate test(149*149)",
                                                               @"adUnitId":@"/14662192/youcamperfect-ios-main-tile-2-test",
                                                               @"Width":@"149",
                                                               @"Height":@"149"},
                                                             @{@"friendlyName":@"Recommen U(320*81)",
                                                               @"adUnitId":@"/14662192/app-recommend-ycp-ios-1",
                                                               @"Width":@"320",
                                                               @"Height":@"81"},
                                                             @{@"friendlyName":@"YCP BC main(320*124)",
                                                               @"adUnitId":@"/14662192/main-page-topbanner-bc-ycp-ios",
                                                               @"Width":@"320",
                                                               @"Height":@"124"},
                                                             @{@"friendlyName":@"YMK BC main(320*124)",
                                                               @"adUnitId":@"/14662192/main-page-topbanner-bc-ymk-ios",
                                                               @"Width":@"320",
                                                               @"Height":@"124"},
                                                             @{@"friendlyName":@"YCN BC main(320*124)",
                                                               @"adUnitId":@"/14662192/main-page-topbanner-bc-ycn-ios",
                                                               @"Width":@"320",
                                                               @"Height":@"124"}
                                                             ]];
    [self showAdUnitIdPickerView:NO withAnimation:NO];
    [self.customTargetingJSONView setText:defaultSampleJSONString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickLoadRequestButton:(UIButton *)sender
{
    self.bannerView.adUnitID = [self refineAdUnitIdTextField];
    CGSize adSize = [self refineSizeTextField];
    CGRect rect = CGRectMake((self.view.frame.size.width - adSize.width)/2, 60, adSize.width, adSize.height);
    self.bannerView.frame = rect;
    [self.errorLogTextView setText:@""];
    DFPRequest *request = [DFPRequest request];
    if (self.customTargetingSwitch.on) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[self.customTargetingJSONView.text dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        if (jsonObject) {
            request.customTargeting = jsonObject;
        }
        else {
            self.errorLogTextView.text = @"JSON format error";
        }
    }
    [self.bannerView loadRequest:request];
}

- (NSString *)refineAdUnitIdTextField
{
    NSString *adUnitId = self.adUnitIdField.text.length!=0 ? self.adUnitIdField.text : defaultAdUnitId;
    self.adUnitIdField.text = adUnitId;
    return adUnitId;
}

- (CGSize)refineSizeTextField
{
    NSInteger adWidth = self.adWidthField.text.length!=0 ? [self.adWidthField.text integerValue] : defaultAdWidth;
    NSInteger adHeight = self.adHeightField.text.length!=0 ? [self.adHeightField.text integerValue] : defaultAdHeight;
    self.adWidthField.text = [[NSString alloc] initWithFormat:@"%ld", (long)adWidth];
    self.adHeightField.text = [[NSString alloc] initWithFormat:@"%ld", (long)adHeight];
    return CGSizeMake(adWidth, adHeight);
}

- (void)showAdUnitIdPickerView:(BOOL)isShow withAnimation:(BOOL)hasAnimation
{
    if (!hasAnimation) {
        if (isShow) {
            self.adUnitIdPickerView.center = CGPointMake(self.adUnitIdPickerView.frame.size.width/2, self.adUnitIdPickerView.frame.size.height/2);
        }
        else {
            self.adUnitIdPickerView.center = CGPointMake(self.adUnitIdPickerView.frame.size.width/2, -self.adUnitIdPickerView.frame.size.height/2);
        }
    }
    else
    {
        if (isShow) {
            [UIView animateWithDuration:0.2f animations:^(void) {
                [self showAdUnitIdPickerView:YES withAnimation:NO];
            } completion:^(BOOL finished) {
                [self showAdUnitIdPickerView:YES withAnimation:NO];
            }];
        }
        else {
            [UIView animateWithDuration:0.2f animations:^(void) {
                [self showAdUnitIdPickerView:NO withAnimation:NO];
            } completion:^(BOOL finished) {
                [self showAdUnitIdPickerView:NO withAnimation:NO];
            }];
        }
    }
}

#pragma mark IBAction

- (IBAction)onEndOfEdit:(UITextField *)testfield
{
    [testfield resignFirstResponder];
    [self refineSizeTextField];
    [self showAdUnitIdPickerView:NO withAnimation:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.adUnitIdField resignFirstResponder];
    [self.adWidthField resignFirstResponder];
    [self.adHeightField resignFirstResponder];
}

- (IBAction)dismissAdUnitIdPickerView:(id)sender {
    [self showAdUnitIdPickerView:NO withAnimation:YES];
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

#pragma mark UITextFieldViewDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self showAdUnitIdPickerView:YES withAnimation:YES];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView == self.customTargetingJSONView && [text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark PickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.adUnitIds.count;
}

#pragma mark PickerViewDelegate


// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.adUnitIds[row][@"friendlyName"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.adUnitIdField.text = self.adUnitIds[row][@"adUnitId"];
    self.adWidthField.text = self.adUnitIds[row][@"Width"];
    self.adHeightField.text = self.adUnitIds[row][@"Height"];
    [self refineSizeTextField];
}

#pragma mark IBAction

- (IBAction)customTargetingSwitchValueChanged:(UISwitch *)sender
{
    self.customTargetingJSONView.editable = sender.on;
    if (sender.on) {
        NSString *language = [DeviceInfoUtility languageCode];
        language = [language stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        self.languageCodeField.text = language;
    }
    else {
        self.languageCodeField.text = nil;
    }
}

@end
