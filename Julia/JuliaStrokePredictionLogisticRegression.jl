#Import Packages
using Pkg
using DataFrames
using CSV
using StatsBase
using GLM
using Lathe
using MLBase
using ClassImbalance
using ScikitLearn

#Enable printing of 1000 columns
ENV["COLUMNS"] = 1000

#Load our data
df = CSV.read("C:\\Users\\olgak\\Documents\\df.csv", DataFrame)
first(df,5)

#See the names of our variables
names(df)

#Check for missing values
[count(ismissing,col) for col in eachcol(df)]

#Check variables' type 
eltype.(eachcol(df))

bmi = replace(df.bmi, "N/A" => "0")

df.bmi = parse.(Float64, bmi)

nm = deleteat!(bmi, findall(bmi->bmi==0.0,df.bmi))

nmm = parse.(Float64, nm)

df

m = mean(nmm)

df.bmi = replace(df.bmi, 0.0 => m)

df

@sk_import preprocessing: LabelEncoder

labelencoder = LabelEncoder() 
categories = [2 6 7 8 11] 
for col in categories 
     df[col] = fit_transform!(labelencoder, df[col]) 
end

df

deletecols!(df, 1)

X2, y2 =smote(df[!,[:gender,:age ,:hypertension, :heart_disease, :ever_married, :work_type, :Residence_type, :avg_glucose_level, :bmi , :smoking_status]], df.stroke, k = 5, pct_under = 150, pct_over = 200)
df_balanced = X2
df_balanced.stroke = y2

df = df_balanced

#Count the classes
countmap(df.stroke)

#Train test split
using Lathe.preprocess: TrainTestSplit
train, test = TrainTestSplit(df,.70);

#Train logistic regression model
fm = @formula(stroke ~ gender + age + hypertension + heart_disease + ever_married + work_type + Residence_type + avg_glucose_level + bmi + smoking_status)
logit = glm(fm, train, Binomial(), ProbitLink())

using MLBase: predict
prediction = predict(logit,test)

#Convert probability score to class
prediction_class = [if x < 0.5 0 else 1 end for x in prediction];
prediction_df = DataFrame(y_actual = test.stroke, y_predicted = prediction_class, prob_predicted = prediction);
prediction_df.correctly_classified = prediction_df.y_actual .== prediction_df.y_predicted

#Accuracy Score
accuracy = mean(prediction_df.correctly_classified)
print("Accuracy of the model is : ",accuracy)

#Confusion Matrix
confusion_matrix = MLBase.roc(prediction_df.y_actual, prediction_df.y_predicted)
