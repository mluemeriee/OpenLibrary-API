# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy everything from the current directory
COPY . .

# DIAGNOSTIC: This will print the file list in your Render logs
RUN ls -la

# Build the project (This looks specifically for the .csproj you just moved)
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

# Entry point for the app
ENTRYPOINT ["dotnet", "MobileApi.csprog"]