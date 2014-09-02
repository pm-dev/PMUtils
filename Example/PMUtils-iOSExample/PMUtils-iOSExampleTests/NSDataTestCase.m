//
//  NSDataTestCase.m
//  PMUtils-iOSExample
//
//  Created by Peter Meyers on 9/1/14.
//  Copyright (c) 2014 Peter Meyers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSData+PMUtils.h"
#import <CommonCrypto/CommonCrypto.h>

@interface NSDataTestCase : XCTestCase

@end

@implementation NSDataTestCase
{
	NSData *_data;
}

- (void)setUp
{
    [super setUp];
	
	_data = [@"DIY flannel Helvetica, +1 blog farm-to-table gastropub mlkshk Neutra tofu typewriter iPhone forage. Roof party hashtag squid paleo. VHS messenger bag pug, literally ethical leggings ugh readymade tote bag craft beer. Swag Godard food truck ethical disrupt lo-fi, selfies wayfarers PBR deep v Etsy flannel keffiyeh ethnic. Banjo VHS food truck, scenester vinyl pug kogi disrupt Schlitz pop-up. Pour-over tousled banh mi, kale chips ethical you probably haven't heard of them Neutra gluten-free DIY irony Truffaut. Sriracha pickled gastropub chia art party literally, locavore Tumblr hella Etsy fingerstache." dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testHexString
{
	NSString *hex = [_data hexString];
	NSString *expectedHex = @"44495920666C616E6E656C2048656C7665746963612C202B3120626C6F67206661726D2D746F2D7461626C652067617374726F707562206D6C6B73686B204E657574726120746F66752074797065777269746572206950686F6E6520666F726167652E20526F6F6620706172747920686173687461672073717569642070616C656F2E20564853206D657373656E67657220626167207075672C206C69746572616C6C79206574686963616C206C656767696E6773207567682072656164796D61646520746F74652062616720637261667420626565722E205377616720476F6461726420666F6F6420747275636B206574686963616C2064697372757074206C6F2D66692C2073656C66696573207761796661726572732050425220646565702076204574737920666C616E6E656C206B65666669796568206574686E69632E2042616E6A6F2056485320666F6F6420747275636B2C207363656E65737465722076696E796C20707567206B6F67692064697372757074205363686C69747A20706F702D75702E20506F75722D6F76657220746F75736C65642062616E68206D692C206B616C65206368697073206574686963616C20796F752070726F6261626C7920686176656E2774206865617264206F66207468656D204E657574726120676C7574656E2D66726565204449592069726F6E792054727566666175742E205372697261636861207069636B6C65642067617374726F707562206368696120617274207061727479206C69746572616C6C792C206C6F6361766F72652054756D626C722068656C6C6120457473792066696E6765727374616368652E";
	XCTAssertEqualObjects(hex, expectedHex, @"Hex strings should be equal");
}

- (void) testSha1Hash
{
	NSData *hash = [_data sha1Hash];
	NSData *hash2 = [_data sha1Hash];
	
	XCTAssert(hash.length == CC_SHA1_DIGEST_LENGTH, @"hash length should be equal to SHA1 digest length");
	XCTAssertEqualObjects(hash, hash2, @"Hashs of same data should be equal");
}


- (void) testMd5Hash
{
	NSData *hash = [_data md5Hash];
	NSData *hash2 = [_data md5Hash];
	
	XCTAssert(hash.length == CC_MD5_DIGEST_LENGTH, @"hash length should be equal to MD5 digest length");
	XCTAssertEqualObjects(hash, hash2, @"Hashs of same data should be equal");
}

@end
