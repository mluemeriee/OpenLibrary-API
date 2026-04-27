# Stage 1: Build using .NET 10 SDK
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /source

# Copy everything from your GitHub repo
COPY . .

# Move into the folder where the code lives
# IMPORTANT: This must match your folder name exactly (Case-Sensitive!)
WORKDIR /source/MobileApi

# Restore and Publish
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime using .NET 10 ASP.NET
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .

# Render's required port
ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# Matches your .csproj name exactly
ENTRYPOINT ["dotnet", "MobileApi.dll"]