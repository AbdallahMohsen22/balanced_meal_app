import 'package:balanced_meal/core/helpers/extensions.dart';
import 'package:balanced_meal/core/helpers/spacing.dart';
import 'package:balanced_meal/core/routing/routes.dart';
import 'package:balanced_meal/core/theming/colors.dart';
import 'package:balanced_meal/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/theming/styles.dart';
import '../models/user_profile.dart';
import '../screens/order_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  Gender? _selectedGender;
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isGenderDropdownOpen = false;

  // Check if all fields are filled
  bool get _isFormValid {
    return _heightController.text.isNotEmpty &&
        _weightController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _selectedGender != null;
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to update the state when text changes
    _heightController.addListener(_updateState);
    _weightController.addListener(_updateState);
    _ageController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Enter your details'),
        titleTextStyle: TextStyles.font20BlackBold,
        backgroundColor: ColorsManager.whiteColor,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              context.pushNamed(Routes.homeScreen);
            },
            child: Icon(Icons.arrow_left_outlined,
                color: Colors.black, size: 25.sp)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpace(30),
                        Text(
                          'Gender',
                          style: TextStyles.font14GreyBold,
                        ),
                        verticalSpace(10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isGenderDropdownOpen = !_isGenderDropdownOpen;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _isGenderDropdownOpen || _selectedGender == null
                                      ? 'Choose your gender'
                                      : _selectedGender == Gender.male
                                      ? 'Male'
                                      : 'Female',
                                  style: TextStyle(
                                    color: _isGenderDropdownOpen || _selectedGender == null
                                        ? Colors.grey
                                        : Colors.black,
                                    fontSize: 16.sp,
                                    fontFamily: "Questrial",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(
                                  _isGenderDropdownOpen
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isGenderDropdownOpen)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.only(top: 4),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedGender = Gender.male;
                                      _isGenderDropdownOpen = false;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    color: _selectedGender == Gender.male
                                        ? const Color(0xFFFFF2EE)
                                        : Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Male',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        if (_selectedGender == Gender.male)
                                          const Icon(Icons.check,
                                              color: Colors.deepOrange),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedGender = Gender.female;
                                      _isGenderDropdownOpen = false;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    color: _selectedGender == Gender.female
                                        ? const Color(0xFFFFF2EE)
                                        : Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Female',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        if (_selectedGender == Gender.female)
                                          const Icon(Icons.check,
                                              color: Colors.deepOrange),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        verticalSpace(30),
                        Text(
                          'Weight',
                          style: TextStyles.font14GreyBold,
                        ),
                        verticalSpace(10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _weightController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your weight',
                                    hintStyle: TextStyles.font16HintColor,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your weight';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'kg',
                                  style: TextStyles.font14GreyBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(30),
                        Text(
                          'Height',
                          style: TextStyles.font14GreyBold,
                        ),
                        verticalSpace(10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _heightController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your height',
                                    hintStyle: TextStyles.font16HintColor,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your height';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Cm',
                                  style: TextStyles.font14GreyBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(30),
                        Text(
                          'Age',
                          style: TextStyles.font14GreyBold,
                        ),
                        verticalSpace(10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: _ageController,
                            decoration: InputDecoration(
                              hintText: 'Enter your age in years',
                              hintStyle: TextStyles.font16HintColor,
                              border: InputBorder.none,
                              contentPadding: const
                              EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your age';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Spacer(),
                        PrimaryButton(
                          buttonText: 'Next',
                          textStyle: TextStyles.font16WhiteBold,
                          backgroundColor: _isFormValid
                              ? ColorsManager.primaryColor
                              : ColorsManager.whiteButtonColor,
                          onPressed: () {
                            // Only proceed if the form is valid
                            if (_isFormValid && _formKey.currentState!.validate()) {
                              final userProfile = UserProfile.calculate(
                                gender: _selectedGender!,
                                weightKg: double.parse(_weightController.text),
                                heightCm: double.parse(_heightController.text),
                                age: int.parse(_ageController.text),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderScreen(userProfile: userProfile),
                                ),
                              );
                            }
                          },
                        ),
                        verticalSpace(20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Remove listeners to prevent memory leaks
    _heightController.removeListener(_updateState);
    _weightController.removeListener(_updateState);
    _ageController.removeListener(_updateState);

    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}