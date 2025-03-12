// parse response and check if SubscriptionPlans exist

const response = pm.response.json();

pm.test("RequestSuccessful " + response.RequestSuccessful, function () {
    pm.expect(response.RequestSuccessful).eq(true);
});

pm.test("SubscriptionPlans count", function () {
    pm.expect(response.Model.SubscriptionPlans.length).to.be.equal(3);
});

// PP001    "Subscription Plan Type A"
// PP002    "Subscription Plan Type B"
// PP003    "Subscription Plan Type C"
// PP004    "Subscription Plan Type D"
// const expectedSubscriptionPlanIds = [PP001, PP002, PP003, PP004];

const expectedSubscriptionPlanIds = [PP001, PP002, PP003];

expectedSubscriptionPlanIds.forEach(expectedId => {
    const foundPlan = response.Model.SubscriptionPlans.find(plan => plan.SubscriptionPlanId === expectedId);
    pm.test(`Find SubscriptionPlanId ${expectedId} - ${foundPlan.Description}`, function () {
        pm.expect(foundPlan.SubscriptionPlanId).to.be.equal(expectedId);
    });
});
