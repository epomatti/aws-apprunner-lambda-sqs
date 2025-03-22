package io.pomatti.app;

import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationEventPublisher;
import org.springframework.security.authentication.DefaultAuthenticationEventPublisher;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import static org.springframework.security.config.Customizer.withDefaults;

@Configuration
@EnableWebSecurity
public class DefaultSecurityConfig {

  @Bean
  public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    // /actuator/health
    http
        .authorizeHttpRequests((requests) -> requests
            .requestMatchers("/actuator/health").permitAll()
            .anyRequest().authenticated())
        .httpBasic(withDefaults())
        .logout((logout) -> logout.permitAll());

    // For testing purposes
    http.csrf((csrf) -> csrf.disable());
    return http.build();
  }

  @Bean
  @ConditionalOnMissingBean(UserDetailsService.class)
  public InMemoryUserDetailsManager inMemoryUserDetailsManager() {
    InMemoryUserDetailsManager manager = new InMemoryUserDetailsManager();
    String generatedPassword = "{noop}p4ssw0rd";
    UserDetails client = User.withUsername("client")
        .password(generatedPassword)
        .roles("USER")
        .build();

    UserDetails lambda = User.withUsername("lambda")
        .password(generatedPassword)
        .roles("USER")
        .build();

    manager.createUser(client);
    manager.createUser(lambda);

    return manager;
  }

  @Bean
  @ConditionalOnMissingBean(AuthenticationEventPublisher.class)
  public DefaultAuthenticationEventPublisher defaultAuthenticationEventPublisher(ApplicationEventPublisher delegate) {
    return new DefaultAuthenticationEventPublisher(delegate);
  }
}
