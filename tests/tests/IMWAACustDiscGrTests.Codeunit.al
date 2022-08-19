codeunit 50100 "IMW AA Cust. Disc. Gr. Tests"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;
        LibraryRandom: Codeunit "Library - Random";
        LibrarySetupStorage: cODEUNIT "Library - Setup Storage";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";

        LibrarySales: Codeunit "Library - Sales";
        IsInitialized: Boolean;

    [HandlerFunctions('ExpectedConfirmHandlerFalse')]
    [Test]
    procedure CheckIfUserSelectNoFromConfirmWindow()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        // [Scenerio]
        Initialize();
        // [GIVEN] On start value of Auto Assigned Cust. Disc. Group is true.
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();
        // [WHEN] Value of Auto Assigned Cust. Disc. is changed for false. Option "No" is selected from Confirm window. 
        SalesReceivablesSetup.Validate("IMW AA Cust. Disc. Gr.", false);
        SalesReceivablesSetup.Modify();
        // [THEN] Value of Auto Assigned Cust. Disc. Group is true.
        Assert.AreEqual(true, SalesReceivablesSetup."IMW AA Cust. Disc. Gr.", 'IMW Auto Ass. Cust. was changed.');
    end;

    [HandlerFunctions('ExpectedConfirmHandlerTrue')]
    [Test]
    procedure CheckIfUserSelectYesFromConfirmWindow()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        // [Scenerio]
        Initialize();
        // [GIVEN] On start value of Auto Assigned Cust. Disc. Group is true.
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();
        // [WHEN] Value of Auto Assigned Cust. Disc. is changed for false. Option "Yes" is selected from Confirm window. 
        SalesReceivablesSetup.Validate("IMW AA Cust. Disc. Gr.", false);
        SalesReceivablesSetup.Modify();
        // [THEN] Value of Auto Assigned Cust. Disc. Group is false.
        Assert.AreEqual(false, SalesReceivablesSetup."IMW AA Cust. Disc. Gr.", 'IMW Auto Ass. Cust. was changed.');
    end;

    [HandlerFunctions('ExpectedMessageHandler')]
    [Test]
    procedure StatusChangeForReleased()
    var
        CustomerDiscountGroup: Record "Customer Discount Group";
        IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        IMWAACustDiscGrSetupTestPage: TestPage "IMW AA Cust. Disc. Gr. Setup";
    begin
        // [Scenerio]
        Initialize();
        // [GIVEN] In IMW Req. Auto. Cust. Disc. Gr. table only one record has value 0 in required field. Status is "Open".
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Open;
        SalesReceivablesSetup.Modify();

        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'Gr1';
        CustomerDiscountGroup.Insert();
        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'Gr2';
        CustomerDiscountGroup.Insert();

        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'Gr1';
        IMWAACustDiscGrSetup."Treshold Amount" := 0;
        IMWAACustDiscGrSetup.Insert();

        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'Gr2';
        IMWAACustDiscGrSetup."Treshold Amount" := 10000;
        IMWAACustDiscGrSetup.Insert();

        // [WHEN] "Release" action is started in Requirements Auto Ass. Disc. Group page.
        IMWAACustDiscGrSetupTestPage.OpenEdit();
        IMWAACustDiscGrSetupTestPage."IMW Release".Invoke();
        // [THEN] Status is changed for "Released".

        SalesReceivablesSetup.Get();
        Assert.AreEqual(SalesReceivablesSetup."IMW AA Status"::Released, SalesReceivablesSetup."IMW AA Status", 'IMW Status is not changed for Released');
        IMWAACustDiscGrSetup.DeleteAll();
        CustomerDiscountGroup.DeleteAll();
    end;

    [HandlerFunctions('ExpectedMessageHandler')]
    [Test]
    procedure StatusNoChangeForReleased()
    var
        CustomerDiscountGroup: Record "Customer Discount Group";
        IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        IMWAACustDiscGrSetupTestPage: TestPage "IMW AA Cust. Disc. Gr. Setup";
    begin
        // [Scenerio]
        Initialize();
        // [GIVEN] In IMW Req. Auto. Cust. Disc. Gr. table only one record has value 0 in required field. Status is "Open".
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Open;
        SalesReceivablesSetup.Modify();

        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'Gr1';
        CustomerDiscountGroup.Insert();
        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'Gr2';
        CustomerDiscountGroup.Insert();

        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'Gr1';
        IMWAACustDiscGrSetup."Treshold Amount" := 1000;
        IMWAACustDiscGrSetup.Insert();

        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'Gr2';
        IMWAACustDiscGrSetup."Treshold Amount" := 10000;
        IMWAACustDiscGrSetup.Insert();

        // [WHEN] "Release" action is started in Requirements Auto Ass. Disc. Group page.
        IMWAACustDiscGrSetupTestPage.OpenEdit();
        IMWAACustDiscGrSetupTestPage."IMW Release".Invoke();
        // [THEN] Status is changed for "Released".

        SalesReceivablesSetup.Get();
        Assert.AreEqual(SalesReceivablesSetup."IMW AA Status"::Open, SalesReceivablesSetup."IMW AA Status", 'IMW Status is changed for Released');

        IMWAACustDiscGrSetup.DeleteAll();
        CustomerDiscountGroup.DeleteAll();
    end;

    [Test]
    procedure CustomerAutoAssignedToDiscGroup()
    var
        Customer: Record Customer;
        CustomerDiscountGroup: Record "Customer Discount Group";
        IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        IMWAACustDiscGrMgt: Codeunit "IMW AA Cust. Disc. Gr. Mgt.";
        IMWAAToDiscGrHist: Record "IMW AA To Disc. Gr. Hist.";
        CustomerCardTestPage: TestPage "Customer Card";

    begin
        // [Scenerio]
        Initialize();

        // [GIVEN] Customer has no discount group. Value of Auto Assigned Cust. Disc. Group is true. Status is "Released".
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Open;
        SalesReceivablesSetup."IMW AA Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();

        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'GR0';
        CustomerDiscountGroup.Insert();
        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'GR0';
        IMWAACustDiscGrSetup."Treshold Amount" := 0;
        IMWAACustDiscGrSetup.Insert();

        Customer.Init();
        Customer."No." := '12345';
        Customer.Name := 'Name1';
        Customer.Insert();

        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Released;
        SalesReceivablesSetup.Modify();

        // [WHEN] "Auto Assign To Disc. Group" action is started in Customer Card page.
        CustomerCardTestPage.OpenEdit();
        CustomerCardTestPage.GoToRecord(Customer);
        CustomerCardTestPage."IMW AA To Disc. Gr.".Invoke();


        // [THEN] Customer is allocated to discount group. 
        Customer.Get('12345');
        Assert.AreEqual(Customer."Customer Disc. Group", 'GR0', 'Customer was not assigned to disc group.');

        IMWAACustDiscGrSetup.DeleteAll();
        CustomerDiscountGroup.DeleteAll();
        Customer.DeleteAll();
        IMWAAToDiscGrHist.DeleteAll();
    end;

    [Test]
    procedure CustomerAutoAssignedToDiscGroupHistory()
    var
        Customer: Record Customer;
        CustomerDiscountGroup: Record "Customer Discount Group";
        IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        IMWAAToDiscGrHist: Record "IMW AA To Disc. Gr. Hist.";
        CustomerCardTestPage: TestPage "Customer Card";

    begin
        // [Scenerio]
        Initialize();

        // [GIVEN] Customer has no discount group. Value of Auto Assigned Cust. Disc. Group is true. Status is "Released".
        If not IMWAAToDiscGrHist.Get() then
            IMWAAToDiscGrHist.Init();
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Open;
        SalesReceivablesSetup."IMW AA Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();

        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'GR0';
        CustomerDiscountGroup.Insert();
        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'GR0';
        IMWAACustDiscGrSetup."Treshold Amount" := 0;
        IMWAACustDiscGrSetup.Insert();

        Customer.Init();
        Customer."No." := '12345';
        Customer.Name := 'Name1';
        Customer.Insert();

        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Released;
        SalesReceivablesSetup.Modify();

        // [WHEN] "Auto Assign To Disc. Group" action is started in Customer Card page.
        CustomerCardTestPage.OpenEdit();
        CustomerCardTestPage.GoToRecord(Customer);
        CustomerCardTestPage."IMW AA To Disc. Gr.".Invoke();

        // [THEN] New record is added to "Assign To Cust. Disc. Group History"
        IMWAAToDiscGrHist.SetFilter(IMWAAToDiscGrHist."Customer No.", '12345');
        Assert.RecordCount(IMWAAToDiscGrHist, 1);

        IMWAACustDiscGrSetup.DeleteAll();
        CustomerDiscountGroup.DeleteAll();
        Customer.DeleteAll();
        IMWAAToDiscGrHist.DeleteAll();
    end;

    [HandlerFunctions('ReportHandlerAll,ExpectedMessageHandler')]
    [Test]
    procedure CustomersAutoAssignedToDiscGroupHistory()
    var
        Customer: Record Customer;
        CustomerDiscountGroup: Record "Customer Discount Group";
        IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        IMWAAToDiscGrHist: Record "IMW AA To Disc. Gr. Hist.";
        IMWAACustDiscGrSetupTestPage: TestPage "IMW AA Cust. Disc. Gr. Setup";
    begin
        // [Scenerio]
        Initialize();

        // [GIVEN] Value of Auto Assigned Cust. Disc. Group is true. Status is "Released".
        If not IMWAAToDiscGrHist.Get() then
            IMWAAToDiscGrHist.Init();
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Open;
        SalesReceivablesSetup."IMW AA Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();

        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'GR0';
        CustomerDiscountGroup.Insert();
        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'GR0';
        IMWAACustDiscGrSetup."Treshold Amount" := 0;
        IMWAACustDiscGrSetup.Insert();

        // Customer.Init();
        // Customer."No." := '123';
        // Customer.Name := 'Name3';
        // Customer.Insert();
        // Customer.Init();
        // Customer."No." := '1234';
        // Customer.Name := 'Name4';
        // Customer.Insert();
        // Customer.Init();
        // Customer."No." := '12345';
        // Customer.Name := 'Name5';
        // Customer.Insert();
        CreateCustomer(Customer);
        CreateCustomer(Customer);
        CreateCustomer(Customer);

        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Released;
        SalesReceivablesSetup.Modify();

        // [WHEN] "Auto Assign Customers To Disc. Group" action is started in Auto Ass. Disc. Group page.
        IMWAACustDiscGrSetupTestPage.OpenView();
        Commit();
        IMWAACustDiscGrSetupTestPage."IWM Auto Ass. All Cust. To Disc. Gr. Report".Invoke();
        //IMWAACustToDiscGroup.Run();

        // [THEN] New records are added to "Assign To Cust. Disc. Group History"
        Assert.RecordCount(IMWAAToDiscGrHist, 3);

        IMWAACustDiscGrSetup.DeleteAll();
        CustomerDiscountGroup.DeleteAll();
        Customer.DeleteAll();
        IMWAAToDiscGrHist.DeleteAll();
    end;

    [Test]
    procedure ErrorCustomerWithoutGroupAddedToSalesDocument()
    var
        Customer: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
    begin
        // [Scenerio]
        Initialize();

        // [GIVEN] Customer has no discount group. Value of Auto Assigned Cust. Disc. Group is true.
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Open;
        SalesReceivablesSetup."IMW AA Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();

        CreateCustomer(Customer);

        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Released;
        SalesReceivablesSetup.Modify();
        SalesHeader.Init();
        SalesHeader."No." := '100000';
        // [WHEN] Customer is added to Sales Order.
        asserterror SetCustomerNoOnSalesHeader(SalesHeader, Customer."No.");

        // [THEN] Error. Customer can't be added.
        Assert.ExpectedError('Customer has invalid assign to Disc. Group. Run action Auto Assign to Disc. Group for this Customer.');

        Customer.DeleteAll();
    end;

    [Test]
    procedure ErrorCustomerInvalidAssignAddedToSalesDocument()
    var
        CustomerDiscountGroup: Record "Customer Discount Group";
        IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup";
        Customer: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
    begin
        // [Scenerio]
        Initialize();

        // [GIVEN] Customer has discount group but date is invalid. Value of Auto Assigned Cust. Disc. Group is true.
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Open;
        SalesReceivablesSetup."IMW AA Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();

        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'GR0';
        CustomerDiscountGroup.Insert();
        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'GR0';
        IMWAACustDiscGrSetup."Treshold Amount" := 0;
        IMWAACustDiscGrSetup.Insert();

        CreateCustomer(Customer);
        Customer."Customer Disc. Group" := 'GR0';
        Customer."IMW AA Disc. Valid To" := CalcDate('<-10D>', Today());
        Customer.Modify();

        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Released;
        SalesReceivablesSetup.Modify();

        SalesHeader.Init();
        SalesHeader."No." := '100000';

        // [WHEN] Customer is added to Sales Order.
        asserterror SetCustomerNoOnSalesHeader(SalesHeader, Customer."No.");

        // [THEN] Error. Customer can't be added.
        Assert.ExpectedError('Customer has invalid assign to Disc. Group. Run action Auto Assign to Disc. Group for this Customer.');
        Customer.DeleteAll();
        IMWAACustDiscGrSetup.DeleteAll();
        CustomerDiscountGroup.DeleteAll();
    end;

    [Test]
    procedure CustomerIsAllocatedDiscGroupAfterInit()
    var
        Customer: Record Customer;
        CustomerDiscountGroup: Record "Customer Discount Group";
        IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        // [Scenerio]
        Initialize();

        // [GIVEN] Value of Auto Assigned Cust. Disc. Group is true. Status is "Released".
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Released;
        SalesReceivablesSetup."IMW AA Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();

        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'GR0';
        CustomerDiscountGroup.Insert();
        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'GR0';
        IMWAACustDiscGrSetup."Treshold Amount" := 0;
        IMWAACustDiscGrSetup.Insert();


        // [WHEN] New Customer is created.
        CreateCustomer(Customer);
        // [THEN] Customer is allocated to discount group.
        Assert.AreEqual(Customer."Customer Disc. Group", 'GR0', 'Customer was not assigned to disc group.');
        Customer.DeleteAll();
        IMWAACustDiscGrSetup.DeleteAll();
        CustomerDiscountGroup.DeleteAll();
    end;

    [Test]
    procedure CustomerIsNotAllocaredDiscGroupAfterInit()
    var
        Customer: Record Customer;
        CustomerDiscountGroup: Record "Customer Discount Group";
        IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        // [Scenerio]
        Initialize();
        // [GIVEN] Value of Auto Assigned Cust. Disc. Group is true. Status is "Open".
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Open;
        SalesReceivablesSetup."IMW AA Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();

        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'GR0';
        CustomerDiscountGroup.Insert();
        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'GR0';
        IMWAACustDiscGrSetup."Treshold Amount" := 0;
        IMWAACustDiscGrSetup.Insert();
        // [WHEN] New Customer is created.
        CreateCustomer(Customer);
        // [THEN] Customer is not allocated to discount group.
        Assert.AreEqual(Customer."Customer Disc. Group", '', 'Customer was assigned to disc group.');
        Customer.DeleteAll();
        IMWAACustDiscGrSetup.DeleteAll();
        CustomerDiscountGroup.DeleteAll();
    end;

    [Test]
    procedure ErrorTheSameValueForThresholdAmountInSetup()
    var
        CustomerDiscountGroup: Record "Customer Discount Group";
        IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        // [Scenerio]
        Initialize();
        // [GIVEN] One discount group has not requirement. 
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW AA Status" := SalesReceivablesSetup."IMW AA Status"::Open;
        SalesReceivablesSetup."IMW AA Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();

        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'GR0';
        CustomerDiscountGroup.Insert();
        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'GR1';
        CustomerDiscountGroup.Insert();
        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'GR2';
        CustomerDiscountGroup.Insert();
        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'GR0';
        IMWAACustDiscGrSetup."Treshold Amount" := 0;
        IMWAACustDiscGrSetup.Insert();
        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Code := 'GR1';
        IMWAACustDiscGrSetup."Treshold Amount" := 1000;
        IMWAACustDiscGrSetup.Insert();
        IMWAACustDiscGrSetup.Init();
        IMWAACustDiscGrSetup.Validate("Code", 'GR2');
        IMWAACustDiscGrSetup."Treshold Amount" := 10;
        IMWAACustDiscGrSetup.Insert();
        // [WHEN] In Requirements Auto Ass. Disc. Group page new record is created. Code is salected. Threshold has the same value like other.
        asserterror SetThresholdAmount(IMWAACustDiscGrSetup, 1000);
        // [THEN] Error. Other Threshold has the same value.
        Assert.ExpectedError('Invalide value. Other Threshold has the same value.');
    end;

    local procedure SetCustomerNoOnSalesHeader(var SalesHeader: Record "Sales Header"; "Customer No.": Code[20])
    begin
        SalesHeader.Validate("Sell-to Customer No.", "Customer No.");
        SalesHeader.Modify();
    end;

    local procedure SetThresholdAmount(var IMWAACustDiscGrSetup: Record "IMW AA Cust. Disc. Gr. Setup"; "Threshold Amount": Decimal)
    begin
        IMWAACustDiscGrSetup.Validate("Treshold Amount", "Threshold Amount");
        IMWAACustDiscGrSetup.Modify();
    end;

    local procedure CreateCustomer(var Customer: Record Customer)
    begin
        LibrarySales.CreateCustomer(Customer);
    end;

    [RequestPageHandler]
    procedure ReportHandlerAll(var IMWAACustToDiscGroup: TestRequestPage "IMW AA Cust. To Disc. Group")
    begin
        IMWAACustToDiscGroup.OK().Invoke();
    end;

    [MessageHandler]
    procedure ExpectedMessageHandler(Msg: Text[1024])
    begin
    end;

    [ConfirmHandler]
    procedure ExpectedConfirmHandlerTrue(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    [ConfirmHandler]
    procedure ExpectedConfirmHandlerFalse(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := false;
    end;

    local procedure Initialize();
    var
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::"IMW AA Cust. Disc. Gr. Tests");
        ClearLastError();
        LibraryVariableStorage.Clear();
        LibrarySetupStorage.Restore();
        if IsInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"IMW AA Cust. Disc. Gr. Tests");

        LibraryRandom.Init();

        // CUSTOMIZATION: Prepare setup tables etc. that are used for all test functions


        IsInitialized := true;
        Commit();

        // CUSTOMIZATION: Add all setup tables that are changed by tests to the SetupStorage, so they can be restored for each test function that calls Initialize.
        // This is done InMemory, so it could be run after the COMMIT above
        //   LibrarySetupStorage.Save(DATABASE::"[SETUP TABLE ID]");

        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"IMW AA Cust. Disc. Gr. Tests");
    end;
}