# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app

# Copy everything
COPY . .

# This command finds your .csproj file automatically and restores it
RUN dotnet restore $(find . -name "*.csproj" | head -n 1)

# This builds the project found above
RUN dotnet publish $(find . -name "*.csproj" | head -n 1) -c Release -o /out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /out .

ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# IMPORTANT: This must match your 'MobileApi.csproj' name exactly
ENTRYPOINT ["dotnet", "MobileApi.dll"]