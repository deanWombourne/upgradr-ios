#import "DWUpgradrResponse.h"

SpecBegin(DWUpgradrResponseSpecs)

describe(@"initialization", ^{

    it(@"can be initialized", ^{
        DWUpgradrResponse *response = [[DWUpgradrResponse alloc] initWithStatus:DWUpgradrResponseStatusOK
                                                          message:@"This is OK"
                                                   currentVersion:@"1.0.0"];
        expect(response).notTo.beNil;
        expect(response.status).to.equal(DWUpgradrResponseStatusOK);
        expect(response.message).to.equal(@"This is OK");
        expect(response.currentVersion).to.equal(@"1.0.0");
    });

});

describe(@"coding", ^{

    it(@"can be coded and decoded", ^{
        DWUpgradrResponse *response1 = [[DWUpgradrResponse alloc] initWithStatus:DWUpgradrResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];

        id data = [NSKeyedArchiver archivedDataWithRootObject:response1];
        expect(data).notTo.beNil;

        DWUpgradrResponse *response2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        expect(response2).notTo.beNil;

        expect(response1).to.equal(response2);
    });

});

describe(@"equality", ^{

    it(@"can be equal", ^{
        DWUpgradrResponse *response1 = [[DWUpgradrResponse alloc] initWithStatus:DWUpgradrResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];
        DWUpgradrResponse *response2 = [[DWUpgradrResponse alloc] initWithStatus:DWUpgradrResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];

        expect(response1).to.equal(response2);
    });

    it(@"can be unequal with status", ^{
        DWUpgradrResponse *response1 = [[DWUpgradrResponse alloc] initWithStatus:DWUpgradrResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];
        DWUpgradrResponse *response2 = [[DWUpgradrResponse alloc] initWithStatus:DWUpgradrResponseStatusOptional
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];

        expect(response1).notTo.equal(response2);
    });

    it(@"can be unequal with message", ^{
        DWUpgradrResponse *response1 = [[DWUpgradrResponse alloc] initWithStatus:DWUpgradrResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];
        DWUpgradrResponse *response2 = [[DWUpgradrResponse alloc] initWithStatus:DWUpgradrResponseStatusOK
                                                           message:@"This is Not OK"
                                                    currentVersion:@"1.0.0"];

        expect(response1).notTo.equal(response2);
    });

    it(@"can be unequal with current version", ^{
        DWUpgradrResponse *response1 = [[DWUpgradrResponse alloc] initWithStatus:DWUpgradrResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.0"];
        DWUpgradrResponse *response2 = [[DWUpgradrResponse alloc] initWithStatus:DWUpgradrResponseStatusOK
                                                           message:@"This is OK"
                                                    currentVersion:@"1.0.1"];

        expect(response1).notTo.equal(response2);
    });
});

SpecEnd
