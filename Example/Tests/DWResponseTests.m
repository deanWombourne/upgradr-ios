#import "DWResponse.h"

SpecBegin(DWResponseSpecs)

describe(@"initialization", ^{

    it(@"can be initialized", ^{
        DWResponse *response = [[DWResponse alloc] initWithStatus:DWResponseStatusOK
                                                          message:@"This is OK"
                                                   currentVersion:@"1.0.0"];
        expect(response).notTo.beNil;
        expect(response.status).to.equal(DWResponseStatusOK);
        expect(response.message).to.equal(@"This is OK");
        expect(response.currentVersion).to.equal(@"1.0.0");
    });

});

describe(@"coding", ^{

    it(@"can be coded and decoded", ^{
        DWResponse *response1 = [[DWResponse alloc] initWithStatus:DWResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];

        id data = [NSKeyedArchiver archivedDataWithRootObject:response1];
        expect(data).notTo.beNil;

        DWResponse *response2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        expect(response2).notTo.beNil;

        expect(response1).to.equal(response2);
    });

});

describe(@"equality", ^{

    it(@"can be equal", ^{
        DWResponse *response1 = [[DWResponse alloc] initWithStatus:DWResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];
        DWResponse *response2 = [[DWResponse alloc] initWithStatus:DWResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];

        expect(response1).to.equal(response2);
    });

    it(@"can be unequal with status", ^{
        DWResponse *response1 = [[DWResponse alloc] initWithStatus:DWResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];
        DWResponse *response2 = [[DWResponse alloc] initWithStatus:DWResponseStatusOptional
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];

        expect(response1).notTo.equal(response2);
    });

    it(@"can be unequal with message", ^{
        DWResponse *response1 = [[DWResponse alloc] initWithStatus:DWResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];
        DWResponse *response2 = [[DWResponse alloc] initWithStatus:DWResponseStatusOK
                                                           message:@"This is Not OK"
                                                    currentVersion:@"1.0.0"];

        expect(response1).notTo.equal(response2);
    });

    it(@"can be unequal with current version", ^{
        DWResponse *response1 = [[DWResponse alloc] initWithStatus:DWResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];
        DWResponse *response2 = [[DWResponse alloc] initWithStatus:DWResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.1"];

        expect(response1).notTo.equal(response2);
    });
});

SpecEnd
