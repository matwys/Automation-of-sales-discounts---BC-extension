codeunit 50100 "IMW  Auto Ass. Cust. Tests"
{
    Subtype = Test;

    var
        LibraryRandom: Codeunit "Library - Random";
        LibraryUtility: Codeunit "Library - Utility";
        Assert: Codeunit Assert;
        IsInitialized: Boolean;
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibrarySetupStorage: cODEUNIT "Library - Setup Storage";

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
        SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();
        // [WHEN] Value of Auto Assigned Cust. Disc. is changed for false. Option "No" is selected from Confirm window. 
        SalesReceivablesSetup.Validate("IMW Auto Ass. Cust. Disc. Gr.", false);
        SalesReceivablesSetup.Modify();
        // [THEN] Value of Auto Assigned Cust. Disc. Group is true.
        Assert.AreEqual(true, SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr.", 'IMW Auto Ass. Cust. was changed.');
    end;

    [ConfirmHandler]
    procedure ExpectedConfirmHandlerFalse(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := false;
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
        SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr." := true;
        SalesReceivablesSetup.Modify();
        // [WHEN] Value of Auto Assigned Cust. Disc. is changed for false. Option "Yes" is selected from Confirm window. 
        SalesReceivablesSetup.Validate("IMW Auto Ass. Cust. Disc. Gr.", false);
        SalesReceivablesSetup.Modify();
        // [THEN] Value of Auto Assigned Cust. Disc. Group is false.
        Assert.AreEqual(false, SalesReceivablesSetup."IMW Auto Ass. Cust. Disc. Gr.", 'IMW Auto Ass. Cust. was changed.');
    end;

    [ConfirmHandler]
    procedure ExpectedConfirmHandlerTrue(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    [HandlerFunctions('ExpectedMessageHandler')]
    [Test]
    procedure StatusChangeForReleased()
    var
        ReqAutoAssDiscGroup: Record "IMW Req. Auto. Cust. Disc. Gr.";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CustomerDiscountGroup: Record "Customer Discount Group";
        IMWReqAutoDiscGrList: TestPage "IMW Req. Auto Disc. Gr. List";
    begin
        // [Scenerio]
        Initialize();
        // [GIVEN] In IMW Req. Auto. Cust. Disc. Gr. table only one record has value 0 in required field. Status is "Open".
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW Status" := SalesReceivablesSetup."IMW Status"::Open;
        SalesReceivablesSetup.Modify();

        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'Gr1';
        CustomerDiscountGroup.Insert();
        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'Gr2';
        CustomerDiscountGroup.Insert();

        ReqAutoAssDiscGroup.Init();
        ReqAutoAssDiscGroup.Code := 'Gr1';
        ReqAutoAssDiscGroup.Required := 0;
        ReqAutoAssDiscGroup.Insert();

        ReqAutoAssDiscGroup.Init();
        ReqAutoAssDiscGroup.Code := 'Gr2';
        ReqAutoAssDiscGroup.Required := 10000;
        ReqAutoAssDiscGroup.Insert();

        // [WHEN] "Release" action is started in Requirements Auto Ass. Disc. Group page.
        IMWReqAutoDiscGrList.OpenEdit();
        IMWReqAutoDiscGrList."IMW Release".Invoke();
        // [THEN] Status is changed for "Released".
        ReqAutoAssDiscGroup.DeleteAll();
        CustomerDiscountGroup.DeleteAll();

        SalesReceivablesSetup.Get();
        Assert.AreEqual(SalesReceivablesSetup."IMW Status"::Released, SalesReceivablesSetup."IMW Status", 'IMW Status is not changed for Released');
    end;

    [HandlerFunctions('ExpectedMessageHandler')]
    [Test]
    procedure StatusNoChangeForReleased()
    var
        ReqAutoAssDiscGroup: Record "IMW Req. Auto. Cust. Disc. Gr.";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        CustomerDiscountGroup: Record "Customer Discount Group";
        IMWReqAutoDiscGrList: TestPage "IMW Req. Auto Disc. Gr. List";
    begin
        // [Scenerio]
        Initialize();
        // [GIVEN] In IMW Req. Auto. Cust. Disc. Gr. table only one record has value 0 in required field. Status is "Open".
        If not SalesReceivablesSetup.Get() then
            SalesReceivablesSetup.Init();
        SalesReceivablesSetup."IMW Status" := SalesReceivablesSetup."IMW Status"::Open;
        SalesReceivablesSetup.Modify();

        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'Gr1';
        CustomerDiscountGroup.Insert();
        CustomerDiscountGroup.Init();
        CustomerDiscountGroup.Code := 'Gr2';
        CustomerDiscountGroup.Insert();

        ReqAutoAssDiscGroup.Init();
        ReqAutoAssDiscGroup.Code := 'Gr1';
        ReqAutoAssDiscGroup.Required := 1000;
        ReqAutoAssDiscGroup.Insert();

        ReqAutoAssDiscGroup.Init();
        ReqAutoAssDiscGroup.Code := 'Gr2';
        ReqAutoAssDiscGroup.Required := 10000;
        ReqAutoAssDiscGroup.Insert();

        // [WHEN] "Release" action is started in Requirements Auto Ass. Disc. Group page.
        IMWReqAutoDiscGrList.OpenEdit();
        IMWReqAutoDiscGrList."IMW Release".Invoke();
        // [THEN] Status is changed for "Released".
        ReqAutoAssDiscGroup.DeleteAll();
        CustomerDiscountGroup.DeleteAll();

        SalesReceivablesSetup.Get();
        Assert.AreEqual(SalesReceivablesSetup."IMW Status"::Open, SalesReceivablesSetup."IMW Status", 'IMW Status is changed for Released');
    end;

    [MessageHandler]
    procedure ExpectedMessageHandler(Msg: Text[1024])
    begin
    end;



    local procedure Initialize();
    var
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
    begin
        LibraryTestInitialize.OnTestInitialize(Codeunit::"IMW  Auto Ass. Cust. Tests");
        ClearLastError();
        LibraryVariableStorage.Clear();
        LibrarySetupStorage.Restore();
        if IsInitialized then
            exit;

        LibraryTestInitialize.OnBeforeTestSuiteInitialize(Codeunit::"IMW  Auto Ass. Cust. Tests");

        LibraryRandom.Init();

        // CUSTOMIZATION: Prepare setup tables etc. that are used for all test functions


        IsInitialized := true;
        Commit();

        // CUSTOMIZATION: Add all setup tables that are changed by tests to the SetupStorage, so they can be restored for each test function that calls Initialize.
        // This is done InMemory, so it could be run after the COMMIT above
        //   LibrarySetupStorage.Save(DATABASE::"[SETUP TABLE ID]");

        LibraryTestInitialize.OnAfterTestSuiteInitialize(Codeunit::"IMW  Auto Ass. Cust. Tests");
    end;
}