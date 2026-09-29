import '../models/document_item_model.dart';
import '../models/process_model.dart';
import '../models/process_step_model.dart';

const String _dlimsFeeNote =
    'DLIMS shows the exact amount when it generates your PSID. Public guides list very different figures, so no single number is shown here.';

const OfficeInfo _licenseOffice = OfficeInfo(
  department: 'Traffic Police Driving License Center',
  cityAddresses: {
    'Lahore': 'CTPL Licensing Center, Manawan Traffic Police, Lahore',
  },
  timings: 'As listed by City Traffic Police Lahore: 9am to 12am, Sunday open',
);

final SourceInfo _dlimsSource = SourceInfo(
  sourceName: 'DLIMS Punjab (Dastak one window portal)',
  url: 'https://dlims.punjab.gov.pk/licensingcenters/',
  lastVerified: DateTime(2026, 9, 1),
);

final SourceInfo _exciseSource = SourceInfo(
  sourceName: 'Punjab Excise and Taxation Department',
  url: 'https://excise.punjab.gov.pk/motorvehicle_tax',
  lastVerified: DateTime(2026, 7, 1),
);

const OfficeInfo _exciseOffice = OfficeInfo(
  department: 'Excise and Taxation Office (Motor Registration)',
  cityAddresses: {},
  timings: 'Mon to Fri, 9am to 3pm',
);

final List<ProcessModel> vehicleProcesses = [
  ProcessModel(
    id: 'vehicle_transfer',
    categoryId: 'vehicles',
    title: 'Vehicle Ownership Transfer',
    summary: 'Transfer a vehicle from the seller to the buyer.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original registration book or smart card', copies: 1),
      DocumentItemModel(
        id: 'd2',
        title: 'CNIC of buyer and seller',
        copies: 2,
        attestationRequired: true,
      ),
      DocumentItemModel(id: 'd3', title: 'Sale letter with notary attestation', copies: 1),
      DocumentItemModel(id: 'd4', title: 'Paid token tax challan', copies: 1),
    ],
    office: _exciseOffice,
    fee: const FeeInfo(
      tiers: [
        FeeTier('Motorcycle', 'Rs. 910'),
        FeeTier('Car up to 1000cc', 'Rs. 4,540'),
        FeeTier('Car 1001cc to 1800cc', 'Rs. 9,075'),
        FeeTier('Car above 1800cc', 'Rs. 18,150'),
        FeeTier('Smart card fee, added to all', 'Rs. 1,300'),
      ],
      notes: 'Rates as listed for Punjab in July 2026. Lifetime token tax may also apply within ten years of first registration.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Submit the transfer form and attested CNIC copies at the counter.',
        'Complete biometric verification of buyer and seller.',
        'Pay the fee and keep the deposit slip.',
      ],
      receiptNote: 'Keep the deposit slip until you receive the new registration.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'About 7 to 10 working days',
      followUp: 'Collect the updated registration from the same office.',
    ),
    source: _exciseSource,
  ),
  ProcessModel(
    id: 'annual_token_tax',
    categoryId: 'vehicles',
    title: 'Annual Token Tax',
    summary: 'Pay the yearly motor vehicle tax online or at the office.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Vehicle registration number', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Owner CNIC copy', copies: 1),
    ],
    office: const OfficeInfo(
      department: 'ePay Punjab or Excise and Taxation Office',
      cityAddresses: {},
      timings: 'Online 24/7. Office: Mon to Fri, 9am to 3pm',
    ),
    fee: const FeeInfo.varies(
      notes: 'Token tax depends on engine capacity and vehicle category. A 10 percent rebate is allowed if the whole year is paid on or before 31 August. Guides disagree on some slabs, so check your exact amount by registration number on ePay Punjab.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Open ePay Punjab and enter your registration number.',
        'Generate the PSID for the amount shown.',
        'Pay through bank, JazzCash, Easypaisa or a 1Link channel.',
      ],
      receiptNote: 'Save the receipt. You need it when you sell or transfer the vehicle.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Immediate',
      followUp: 'Set a reminder for next year using your Saved Details.',
    ),
    source: _exciseSource,
  ),
  ProcessModel(
    id: 'new_vehicle_registration',
    categoryId: 'vehicles',
    title: 'New Vehicle Registration',
    summary: 'Register a newly bought vehicle in your name.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Sale invoice from dealer or manufacturer', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Original CNIC', copies: 1),
      DocumentItemModel(id: 'd3', title: 'Customs clearance papers, for imported vehicles', copies: 1),
    ],
    office: _exciseOffice,
    fee: const FeeInfo.varies(
      notes: 'Registration fee depends on the vehicle category and engine size. An additional fee applies if the vehicle is not registered within the prescribed period after sale, import or release.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Submit the registration form with the sale invoice at the counter.',
        'Pay the fee and token tax shown at the counter.',
        'Get your number plate and registration issued.',
      ],
      receiptNote: 'Keep the deposit slip and invoice together.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'About 7 to 10 working days',
      followUp: 'Collect the registration and number plate.',
    ),
    source: _exciseSource,
  ),
  ProcessModel(
    id: 'learner_permit',
    categoryId: 'vehicles',
    title: 'Learner Driving Permit',
    summary: 'The first step before a permanent driving license.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Passport size photographs', copies: 2),
    ],
    office: _licenseOffice,
    fee: const FeeInfo.varies(notes: _dlimsFeeNote),
    submit: const SubmitInfo(
      instructions: [
        'Apply online through DLIMS on the Dastak portal, or at a licensing center.',
        'Pass the basic theory test.',
        'Pay the amount on your PSID.',
      ],
      receiptNote: 'A learner permit alone does not allow you to drive without a licensed adult.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Digital copy after payment is confirmed',
      followUp: 'You can apply for the permanent license after the required waiting period.',
    ),
    source: _dlimsSource,
  ),
  ProcessModel(
    id: 'permanent_license',
    categoryId: 'vehicles',
    title: 'Permanent Driving License',
    summary: 'Get a smart card license for motorcycle, car or other categories.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Learner permit', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Original CNIC', copies: 1),
      DocumentItemModel(id: 'd3', title: 'Medical certificate, if you are above 50', copies: 1),
    ],
    office: _licenseOffice,
    fee: const FeeInfo.varies(notes: _dlimsFeeNote),
    submit: const SubmitInfo(
      instructions: [
        'Book your driving test slot after the waiting period.',
        'Pass the theory and practical driving test.',
        'Pay the amount on your PSID and give your biometrics.',
      ],
      receiptNote: 'Keep your test slip and payment receipt.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Smart card delivery usually takes a couple of weeks',
      followUp: 'The card is delivered by courier.',
    ),
    source: _dlimsSource,
  ),
  ProcessModel(
    id: 'license_renewal',
    categoryId: 'vehicles',
    title: 'Driving License Renewal',
    summary: 'Renew an expiring or expired driving license.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Old driving license', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Original CNIC', copies: 1),
    ],
    office: _licenseOffice,
    fee: const FeeInfo.varies(
      notes: 'Renewal is charged by license category, and late renewal adds a fine that grows with the delay. $_dlimsFeeNote',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Open DLIMS on Dastak and choose renewal.',
        'Pay the amount on your PSID including any fine.',
      ],
      receiptNote: 'Keep the receipt until the new card is delivered.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Card delivery usually takes a couple of weeks',
      followUp: 'The new card arrives by courier.',
    ),
    source: _dlimsSource,
  ),
  ProcessModel(
    id: 'international_permit',
    categoryId: 'vehicles',
    title: 'International Driving Permit',
    summary: 'Needed to drive abroad along with your Pakistani license.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Valid permanent driving license', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Passport and visa copy', copies: 1),
      DocumentItemModel(id: 'd3', title: 'Passport size photographs', copies: 2),
    ],
    office: _licenseOffice,
    fee: const FeeInfo.varies(notes: _dlimsFeeNote),
    submit: const SubmitInfo(
      instructions: [
        'Apply with your local license, passport and visa copy.',
        'Pay the amount on your PSID.',
      ],
      receiptNote: 'Always carry the permit together with your local license.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'A few working days',
      followUp: 'The permit is valid for one year, then it must be renewed.',
    ),
    source: _dlimsSource,
  ),
];
