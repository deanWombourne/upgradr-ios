#import "DWUpgradrResponseSerializer.h"

SpecBegin(DWUpgradrResponseSerializer)

describe(@"Serializer", ^{

    it(@"can parse valid data", ^{
        NSString *validResponse = @"{\"status\":\"REQUIRED\",\"message\":\"Update required\",\"minimum_version\":\"0.0.2\",\"current_version\":\"0.1.0\"}";
        NSData *validResponseData = [validResponse dataUsingEncoding:NSUTF8StringEncoding];

        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"www.example.com/api/verify"]
                                                            MIMEType:@"application/json"
                                               expectedContentLength:validResponseData.length
                                                    textEncodingName:nil];

        DWUpgradrResponseSerializer *s = [[DWUpgradrResponseSerializer alloc] init];

        NSError *error = nil;
        DWUpgradrResponse *result = [s responseObjectForResponse:response
                                                            data:validResponseData
                                                           error:&error];

        expect(result).to.beInstanceOf([DWUpgradrResponse class]);

        expect(result.status).to.equal(DWUpgradrResponseStatusRequired);
        expect(result.message).to.equal(@"Update required");
        expect(result.currentVersion).to.equal(@"0.1.0");
    });
});

SpecEnd
