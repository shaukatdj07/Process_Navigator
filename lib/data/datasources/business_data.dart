import '../models/document_item_model.dart';
import '../models/process_model.dart';
import '../models/process_step_model.dart';

const OfficeInfo _fbrOnline = OfficeInfo(
  department: 'FBR IRIS Portal',
  cityAddresses: {},
  timings: 'Online, available all day',
  fallbackNote: 'This is done online on the FBR IRIS portal, no office visit is needed.',
);

const OfficeInfo _secpOnline = OfficeInfo(
  department: 'SECP eZfile Portal',
  cityAddresses: {},
  timings: 'Online, available all day',
  fallbackNote: 'This is done online on the SECP eZfile portal, no office visit is needed.',
);

final List<ProcessModel> businessProcesses = [
  ProcessModel(
    id: 'ntn_registration',
    categoryId: 'business',
    title: 'NTN Registration',
    summary: 'Enrol with FBR to get your National Tax Number.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Mobile SIM registered in your own name', copies: 1),
      DocumentItemModel(id: 'd3', title: 'Recent utility bill, for business registration', copies: 1),
    ],
    office: _fbrOnline,
    fee: const FeeInfo(
      tiers: [FeeTier('FBR government fee', 'Free')],
      notes: 'For individuals your CNIC number itself becomes the NTN. Consultants charge their own fee if you use one.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Open iris.fbr.gov.pk and choose new registration.',
        'Verify your CNIC, mobile number and email.',
        'Fill in the details and submit.',
      ],
      receiptNote: 'Save your login details, you need them every year to file returns.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Individual registration is usually processed in a day or two',
      followUp: 'To appear on the Active Taxpayer List you must also file a return.',
    ),
    source: SourceInfo(
      sourceName: 'Federal Board of Revenue, register for income tax',
      url: 'https://www.fbr.gov.pk/categ/register-income-tax/51147/30846/71148',
      lastVerified: DateTime(2026, 9, 1),
    ),
  ),
  ProcessModel(
    id: 'sales_tax_registration',
    categoryId: 'business',
    title: 'Sales Tax Registration',
    summary: 'Register your business for sales tax with FBR.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'NTN or CNIC', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Business bank account details', copies: 1),
    ],
    office: const OfficeInfo(
      department: 'FBR IRIS Portal and NADRA e Sahulat Center',
      cityAddresses: {},
      timings: 'Online, then a NADRA e Sahulat visit for biometrics',
      fallbackNote: 'Apply online, then visit any NADRA e Sahulat center for biometric verification.',
    ),
    fee: const FeeInfo(
      tiers: [FeeTier('FBR government fee', 'Free')],
      notes: 'You must complete biometric verification at a NADRA e Sahulat center within 30 days or your name is taken off the Sales Tax Active Taxpayer List.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Fill the sales tax registration form on IRIS, or use the Iris or Tax Asaan mobile app.',
        'Visit a NADRA e Sahulat center within 30 days for biometrics.',
      ],
      receiptNote: 'Keep the verification receipt from the e Sahulat center.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Active after biometric verification',
      followUp: 'Sales tax returns must then be filed regularly.',
    ),
    source: SourceInfo(
      sourceName: 'Federal Board of Revenue, register for sales tax',
      url: 'https://www.fbr.gov.pk/categ/register-sales-tax/51148/50848/%20101152',
      lastVerified: DateTime(2026, 9, 1),
    ),
  ),
  ProcessModel(
    id: 'income_tax_return',
    categoryId: 'business',
    title: 'Income Tax Return Filing',
    summary: 'File your yearly income tax return on IRIS.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Salary slips or business income record', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Bank statements', copies: 1),
      DocumentItemModel(id: 'd3', title: 'Record of assets and loans', copies: 1),
    ],
    office: _fbrOnline,
    fee: const FeeInfo(
      tiers: [FeeTier('FBR government fee', 'Free')],
      notes: 'There is no government fee to file yourself. A consultant will charge separately.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Log in to IRIS with your NTN and password.',
        'Fill in the income and wealth statement.',
        'Submit the return and save the acknowledgment.',
      ],
      receiptNote: 'Keep the acknowledgment for your records.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'The return for tax year 2026 is due by 30 September 2026',
      followUp: 'Filing puts you on the Active Taxpayer List, which lowers withholding tax.',
    ),
    source: SourceInfo(
      sourceName: 'FBR IRIS portal',
      url: 'https://iris.fbr.gov.pk/NewRegistration',
      lastVerified: DateTime(2026, 9, 1),
    ),
  ),
  ProcessModel(
    id: 'secp_private_limited',
    categoryId: 'business',
    title: 'Private Limited Company Registration',
    summary: 'Register a company with SECP through eZfile.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'CNIC of all directors and shareholders', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Memorandum and Articles of Association', copies: 1),
    ],
    office: _secpOnline,
    fee: const FeeInfo(
      tiers: [
        FeeTier('Online incorporation, capital up to Rs. 100,000', 'From Rs. 1,800'),
        FeeTier('Name reservation', 'Rs. 1,000'),
        FeeTier('eZfile user registration, one time per user', 'Rs. 200'),
      ],
      notes: 'The incorporation fee rises with authorized capital. Use the SECP fee calculator for the exact amount.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Create eZfile accounts for every director.',
        'Reserve the company name.',
        'Upload the incorporation documents and pay the fee.',
      ],
      receiptNote: 'You receive a digitally signed certificate with a CUIN number.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'About 2 to 5 working days',
      followUp: 'Register with FBR for NTN and open a business bank account.',
    ),
    source: SourceInfo(
      sourceName: 'SECP company registration guide',
      url: 'https://sterling.pk/secp-pvt-ltd-registration-2026/',
      lastVerified: DateTime(2026, 4, 8),
    ),
  ),
  ProcessModel(
    id: 'secp_single_member',
    categoryId: 'business',
    title: 'Single Member Company Registration',
    summary: 'Limited liability company owned by one person.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'CNIC of the sole director', copies: 1),
      DocumentItemModel(id: 'd2', title: 'CNIC of the nominee director (next of kin)', copies: 1),
    ],
    office: _secpOnline,
    fee: const FeeInfo(
      tiers: [
        FeeTier('Online incorporation, small capital', 'About Rs. 1,800 to Rs. 2,500'),
        FeeTier('Name reservation', 'Rs. 1,000'),
      ],
      notes: 'Some websites quote a much higher flat fee for single member companies. The SECP fee calculator is the reliable check.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Create eZfile accounts for the sole director and the nominee.',
        'Reserve the company name.',
        'Submit the incorporation documents and pay.',
      ],
      receiptNote: 'The certificate of incorporation carries a CUIN and a QR code.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'About 2 to 5 working days',
      followUp: 'Get your NTN and business bank account.',
    ),
    source: SourceInfo(
      sourceName: 'SECP fee guide',
      url: 'https://jzarrfilers.com/blog/secp-registration-fee/',
      lastVerified: DateTime(2026, 7, 27),
    ),
  ),
];
